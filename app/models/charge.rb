# app/models/charge.rb

class Charge < ActiveRecord::Base
  belongs_to :charged_to, :class_name => "User", :foreign_key => "user_id"
  belongs_to :expense
  has_one :paid_by, :through => :expense

  def charge_to user
    curr = current_user
  end

  def date_formatted
    self.created_at.strftime("%a, %b #{self.created_at.day.ordinalize}")
  end

  def amount_formatted
    amount_formatted_with_decimal
  end

  def amount_formatted_slim
    if self.amount % 1 == 0
      amount_formatted_without_decimal
    else
      amount_formatted_with_decimal
    end
  end
  
  def amount_formatted_with_decimal
    "$" + number_with_precision(self.amount, :precision => 2, :delimiter => ',')
  end

  def amount_formatted_without_decimal
    "$" + number_with_precision(self.amount, :precision => 0, :delimiter => ',')
  end
  
end
