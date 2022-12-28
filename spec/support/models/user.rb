# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :username, presence: true
end
