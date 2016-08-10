class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_current_user, :only => "reply"

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    boot_twilio
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Hello there, thanks for texting me. Your number is #{from_number}."
    )
    render xml: {}
  end

  private

  def boot_twilio
    account_sid = ENV["TWILIO_SID"]
    auth_token = ENV["TWILIO_TOKEN"]
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

end
