class House < ActiveRecord::Base
    has_many :users
    has_many :landlords
    has_one :fine_rule
    has_many :expenses, :through => :users
end
