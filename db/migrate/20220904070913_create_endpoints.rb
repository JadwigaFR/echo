# frozen_string_literal: true

class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string :verb, null: false
      t.string :path, null: false
      t.integer :response_code, null: false
      t.json :response_headers, default: {}
      t.text :response_body

      t.index %i[path verb], unique: true

      t.timestamps
    end
  end
end
