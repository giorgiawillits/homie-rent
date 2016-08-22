class CreateLandlords < ActiveRecord::Migration
  def change
    create_table :landlords do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :best_contact_method
      t.string :notes
      t.belongs_to :house, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
