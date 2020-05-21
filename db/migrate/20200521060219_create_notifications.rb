# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :date
      t.string :content
      t.references :trial, null: false, foreign_key: true

      t.timestamps
    end
  end
end
