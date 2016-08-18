# app/models/expense.rb
include ActionView::Helpers::NumberHelper

class Expense < ActiveRecord::Base
  belongs_to :paid_by, :class_name => "User", :foreign_key => 'user_id'
  has_many :charges
  has_many :jobs, :class_name => "::Delayed::Job", :as => :owner

  after_create :reminder
  after_save :update_reminders
  after_destroy :delete_reminders

  # @@REMINDER_TIME = 1.day # days before deadline
  @@REMINDER_TIME = 1.minute # days before deadline

  def date_formatted
    self.date.strftime("%a, %b #{self.date.day.ordinalize}")
  end

  def deadline_formatted
    self.deadline.strftime("%a, %b #{self.deadline.day.ordinalize}")
  end

  def amount_formatted
    if self.amount % 1 == 0
      number_with_delimiter(self.amount, :delimiter => ',')
      # number_with_precision(self.amount, :precision => 0, :delimiter => ',')
      # "$%.0f" % self.amount
    else
      number_with_precision(self.amount, :precision => 2, :delimiter => ',')
      # "$%.2f" % self.amount
    end
  end

  def completed?
    self.charges.all? { |charge| charge.completed }
  end

  def overdue?
    self.deadline and self.deadline < Time.now
  end

  def percent_complete
    if self.charges.length == 0
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

  def when_to_run
    self.deadline - @@REMINDER_TIME
  end

  # Notify those charged who havent paid yet X days before the deadline
  def reminder
    send_reminders self.charges.where(:completed => false)
  end
  # handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }, :owner => Proc.new { |o| o }
  handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }, :owner_type => Proc.new { |o| o.class.name }, :owner_id => Proc.new { |o| o.id }

  def send_reminders charges
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    deadline_str = deadline_formatted
    paid_by_name = self.paid_by.first_name.capitalize
    late_fee = 50.to_s
    expense_name = self.name

    charges.each do |charge|
      name = charge.charged_to.first_name.capitalize
      amount = charge.amount_formatted
      phone_number = charge.charged_to.phone_number
      reminder = "Hi #{name}. Please pay #{paid_by_name} #{amount} for #{expense_name} by #{deadline_str} in order to avoid a late fee of $#{late_fee}. If you have already completed this charge, reply COMPLETED #{charge.id}."

      message = @client.account.messages.create(
        :from => @twilio_number,
        :to => phone_number,
        :body => reminder)
    end
  end

  def update_reminders
    if self.jobs.first.run_at != self.when_to_run
      self.jobs.first.update_attributes(:run_at => Proc.new { |i| i.when_to_run })
      # reminder
    end
  end

  def delete_reminders
    self.jobs.destroy_all
  end

end
