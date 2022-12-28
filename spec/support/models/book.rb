# frozen_string_literal: true

class Book < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :owner, polymorphic: [Publisher, User]
end
