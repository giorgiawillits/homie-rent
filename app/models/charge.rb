# app/models/charge.rb

class Charge < ActiveRecord::Base
  belongs_to :charged_to, :class_name => "User"
  has_one :paid_by, :through => :expense
  belongs_to :expense

  def charge_to user
    curr = current_user
  end

  def date_formatted
    self.created_at.strftime("%a, %b #{self.created_at.day.ordinalize}")
  end

  def amount_formatted
    if self.amount % 1 == 0
      "$%.0f" % self.amount
    else
      "$%.2f" % self.amount
    end
  end

end
