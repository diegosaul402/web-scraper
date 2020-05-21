# frozen_string_literal: true

class CreateTrials < ActiveRecord::Migration[6.0]
  def change
    create_table :trials do |t|
      t.string :title
      t.string :actor
      t.string :defendant
      t.string :expedient
      t.string :summary
      t.string :court

      t.timestamps
    end
  end
end
