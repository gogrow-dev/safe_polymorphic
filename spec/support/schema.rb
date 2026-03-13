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

  create_table :other_things, force: true do |t|
    t.integer :thing_id
    t.string :thing_type

    t.timestamps
  end

  create_table :addresses, force: true do |t|
    t.integer :addressable_id
    t.string :addressable_type
    t.string :type

    t.timestamps
  end

  create_table :house_addresses, force: true do |t|
    t.integer :address_id
    t.string :style

    t.timestamps
  end

  create_table :office_addresses, force: true do |t|
    t.integer :address_id
    t.integer :floors

    t.timestamps
  end
end
