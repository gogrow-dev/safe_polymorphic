# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :books, force: true do |t|
    t.string :title
    t.integer :owner_id
    t.string :owner_type

    t.timestamps
  end

  create_table :publishers, force: true do |t|
    t.string :name

    t.timestamps
  end

  create_table :users, force: true do |t|
    t.string :username

    t.timestamps
  end

  create_table :other_things, force: true, &:timestamps
end
