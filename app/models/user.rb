# app/models/user.rb

class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: ": an email is incorrectly formatted" }
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  belongs_to :house
  
  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end 
  
end