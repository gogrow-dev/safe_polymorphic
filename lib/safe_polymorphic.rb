# frozen_string_literal: true

require_relative 'safe_polymorphic/version'
require 'active_record'
require_relative 'safe_polymorphic/associations'

I18n.load_path << File.expand_path('config/locales/en.yml')

module SafePolymorphic
  class Error < StandardError; end
end

# Extend ActiveRecord::Base with belongs to polymorphic associations
ActiveRecord::Base.include SafePolymorphic::Associations
