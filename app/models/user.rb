# app/models/user.rb

class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar,
    :default_url => "/assets/blank_user.png",
    :s3_protocol => "https",
    styles: {
      small: '100x100>',
      square: '200x200#',
      normal: '300x300>'
    }
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :email, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: ": an email is incorrectly formatted" }
  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :house
  has_many :expenses
  has_many :charges     #TODO: should we rename this to charges_against? -> has_many :charges, :class_name => "Charge", :as => :charges_against

  def all_activities
    activities = []
    self.expenses.each do |expense|
      activities += [{:type => "expense", :object => expense}]
    end
    self.charges.each do |charge|
      activities += [{:type => "charge", :object => charge}]
    end
    activities.sort do |a, b|
      # TODO: what is this printing for?
      puts "A", a
      puts "B", b
      b[:object].created_at <=> a[:object].created_at
    end
  end

  def profile_pic_url size
    if self.uid
      "https://graph.facebook.com/#{self.uid}/picture?type=#{size}"
    else
      self.avatar.url(size)
    end
  end

  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end

  def first_name_initial
    self.first_name.capitalize + " " + self.last_name.capitalize[0] + "."
  end

end
