# frozen_string_literal: true

require_relative 'safe_polymorphic/version'
require 'active_record'
require_relative 'safe_polymorphic/associations'

module SafePolymorphic
  class Error < StandardError; end
end

ActiveSupport.on_load(:i18n) do
  I18n.load_path << File.expand_path('safe_polymorphic/locales/en.yml', __dir__)
end

# Extend ActiveRecord::Base with belongs to polymorphic associations
ActiveRecord::Base.include SafePolymorphic::Associations
