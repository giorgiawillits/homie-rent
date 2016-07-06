class AddUserToCharges < ActiveRecord::Migration
  def change
    add_reference :charges, :charged_to, index: true, foreign_key: true
  end
end
