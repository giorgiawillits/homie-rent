# app/models/expense.rb

class Expense < ActiveRecord::Base
  belongs_to :paid_by, :class_name => "User"
  has_many :charges
  
  def completed?
    self.charges.all? { |charge| charge.completed }
  end
  
  def overdue?
    self.deadline and self.deadline < Time.now 
  end
  
  def percent_complete
    if not self.charges.length
      return 0
    end
    complete = 0
    self.charges.each do |charge|
      if charge.completed
        complete += 1
      end
    end
    decimal = complete.to_f / self.charges.length
    return (decimal * 100).to_i.to_s
  end 
end
