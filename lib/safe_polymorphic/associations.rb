# frozen_string_literal: true

module SafePolymorphic
  module Associations
    def self.included(base)
      base.extend ClassMethods
      class << base
        alias_method :unsafe_polymorphic, :belongs_to
        alias_method :belongs_to, :safe_polymorphic
      end
    end

    module ClassMethods
      def safe_polymorphic(name, **options)
        unsafe_polymorphic name, **options
        polymorphic = options[:polymorphic]

        return unless polymorphic.present? && polymorphic.class != TrueClass

        allowed_classes = classify(polymorphic)

        validates "#{name}_type", inclusion: inclusion_validation(allowed_classes, options[:optional])

        define_singleton_method("#{name}_types") { allowed_classes }
        define_generic_finder_method(name)
        define_scopes_and_instance_methods(name, allowed_classes)
      end

      private

      def inclusion_validation(allowed_classes, optional)
        {
          in: inclusion_classes(allowed_classes, optional),
          message: I18n.t('safe_polymorphic.errors.messages.class_not_allowed',
                          class: '%<value>s')
        }
      end

      def classify(classes)
        Array.wrap(classes).map do |klass|
          case klass
          when Class then klass
          else constantize(klass)
          end
        end
      end

      def constantize(klass)
        const_class = case klass
                      when String then klass
                      when Symbol then klass.to_s
                      else klass.class.name
                      end
        const_class.classify.constantize
      end

      def inclusion_classes(allowed_classes, optional)
        classes = allowed_classes.map(&:name)
        classes << nil if optional.present?
        classes
      end

      # Generates a generic finder method
      def define_generic_finder_method(name)
        define_singleton_method("with_#{name}") do |type|
          type = constantize(type) unless type.is_a?(Class)
          where("#{name}_type" => type.name)
        end
      end

      def define_scopes_and_instance_methods(name, allowed_classes)
        allowed_classes.each do |model|
          model_name = model.name
          model_name_sanitized = model_name.underscore.tr('/', '_')
          # generates scope for each allowed class
          scope "with_#{name}_#{model_name_sanitized}",
                -> { where("#{name}_type" => model_name) }

          # generates instance method for each allowed class to check if type is that class
          define_method("#{name}_type_#{model_name_sanitized}?") do
            public_send("#{name}_type") == model_name
          end
        end
      end
    end
  end
end
