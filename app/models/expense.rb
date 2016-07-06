# app/models/expense.rb

class Expense < ActiveRecord::Base
  belongs_to :paid_by, :class_name => "User"
  has_many :charges
end
