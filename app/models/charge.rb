# app/models/charge.rb

class Charge < ActiveRecord::Base
  belongs_to :charged_to, :class_name => "User"
  has_one :paid_by, :through => :expense
  belongs_to :expense
  
  def charge_to user
    curr = current_user
    
  end
  
end
