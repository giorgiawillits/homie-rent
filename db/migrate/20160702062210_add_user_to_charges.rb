class AddUserToCharges < ActiveRecord::Migration
  def change
    add_reference :charges, :user, index: true, foreign_key: true
  end
end
