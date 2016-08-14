class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_current_user, :only => [:reply, :reply_to_reminder]

  def reply
    message_body = params[:Body]
    from_number = params[:From]
    boot_twilio
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Hello there, thanks for texting me. Your number is #{from_number}."
    )
    render xml: {}
  end

  def reply_to_reminder
    incoming = params[:From].gsub(/^\+\d/, '')
    puts :incoming, incoming
    sms_input = params[:Body].downcase
    if sms_input =~ /completed ([0-9]*)/
      expense = Expense.find_by_id($1)
      paid_by = expense.paid_by
      user_charged = User.find_by_phone_number(incoming)
      amount = expense.charges.where(:charged_to => user_charged).first.amount

      message = "#{user_charged.first_name} says that they have completed your charge of $#{amount} for #{expense.name}. To confirm that they have completed this charge, reply CONFIRM COMPLETED #{expense.id}"

      boot_twilio
      sms = @client.messages.create(
        from: ENV["TWILIO_NUMBER"],
        to: paid_by.phone_number,
        body: message)
    end
    render xml: {}
  end

  private

  def boot_twilio
    account_sid = ENV["TWILIO_SID"]
    auth_token = ENV["TWILIO_TOKEN"]
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

end
