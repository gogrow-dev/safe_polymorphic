# frozen_string_literal: true

class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: [Publisher, User]
  delegated_type :type, types: %w[House Office], dependent: :destroy
end
