class AddDeadlineToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :deadline, :datetime
  end
end
