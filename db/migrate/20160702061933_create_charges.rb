class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.boolean :completed
      t.float :amount
      t.belongs_to :expense, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
