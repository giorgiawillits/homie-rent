# app/models/expense.rb
include ActionView::Helpers::NumberHelper
require 'utils'

class Expense < ActiveRecord::Base
  include Formattable
  belongs_to :paid_by, :class_name => "User", :foreign_key => 'user_id'
  has_many :charges
  has_many :jobs, :class_name => "::Delayed::Job", :as => :owner

  after_create :reminder
  # after_save :update_reminders
  # after_destroy :delete_reminders

  # @@REMINDER_TIME = 1.day # days before deadline
  @@REMINDER_TIME = 1.minute # days before deadline

  def date_formatted
    format_date self.date
  end

  def deadline_formatted
    format_date self.deadline
  end

  def amount_formatted
    format_amount_with_decimal self.amount
  end

  def amount_formatted_plain
    format_amount_with_decimal_plain self.amount
  end

  def amount_formatted_slim
    format_amount_slim self.amount
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
    logger.info "called reminder"
    logger.info "expense: #{self.name}"
    send_reminders self.charges.where(:completed => false)
  end

  # handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }, :owner => Proc.new { |o| o }
  handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }, :owner_type => Proc.new { |o| o.class.name }, :owner_id => Proc.new { |o| o.id }

  def send_reminders charges
    logger.info "called send_reminders"
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    deadline_str = deadline_formatted
    paid_by_name = self.paid_by.first_name.capitalize
    late_fee = 50.to_s
    expense_name = self.name

    charges.each do |charge|
      logger.info "charge: #{charge.charged_to.first_name}"
      name = charge.charged_to.first_name.capitalize
      amount = charge.amount_formatted_slim
      phone_number = charge.charged_to.phone_number
      reminder = "Hi #{name}. Please pay #{paid_by_name} #{amount} for #{expense_name} by #{deadline_str} in order to avoid a late fee of $#{late_fee}. If you have already completed this charge, reply COMPLETED #{charge.id}."

      logger.info "phone_number: #{phone_number}"
      message = @client.account.messages.create(
        :from => @twilio_number,
        :to => phone_number,
        :body => reminder)
    end
  end

  # def update_reminders
  #   if self.jobs.first.run_at != self.when_to_run
  #     self.jobs.first.update_attributes(:run_at => Proc.new { |i| i.when_to_run })
  #     # reminder
  #   end
  # end

  # def delete_reminders
  #   self.jobs.destroy_all
  # end

end
