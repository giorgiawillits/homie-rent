class AddUserToExpenses < ActiveRecord::Migration
  def change
    add_reference :expenses, :paid_by, index: true, foreign_key: true
  end
end
