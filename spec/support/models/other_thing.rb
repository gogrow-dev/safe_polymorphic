# frozen_string_literal: true

class OtherThing < ActiveRecord::Base
  belongs_to :thing, polymorphic: ['user', :publisher], optional: true
end
