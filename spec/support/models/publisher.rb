# frozen_string_literal: true

class Publisher < ActiveRecord::Base
  validates :name, presence: true
end
