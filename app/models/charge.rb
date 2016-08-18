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
    if self.amount % 1 == 0
      "$" + number_with_precision(self.amount, :precision => 0, :delimiter => ',')
    else
      "$" + number_with_precision(self.amount, :precision => 2, :delimiter => ',')
    end
  end

end
