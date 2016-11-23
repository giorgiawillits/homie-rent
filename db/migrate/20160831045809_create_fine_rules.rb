class CreateFineRules < ActiveRecord::Migration
  def change
    create_table :fine_rules do |t|
      t.integer :amount
      t.boolean :reminder
      t.integer :days_before_deadline
      t.belongs_to :house, index: true, foreign_key: true
    end
  end
end
