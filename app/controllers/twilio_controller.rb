class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_current_user, :only => "reply"

  def reply
    me
  end

end