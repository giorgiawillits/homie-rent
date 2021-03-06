# app/models/charge.rb
require 'utils'

class Charge < ActiveRecord::Base
  include Formattable
  belongs_to :charged_to, :class_name => "User", :foreign_key => "user_id"
  belongs_to :expense
  has_one :paid_by, :through => :expense

  def charge_to user
    curr = current_user
  end

  def date_formatted
    format_date self.created_at
  end

end
