# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Charge.destroy_all
Expense.destroy_all
User.destroy_all
Delayed::Job.destroy_all
Landlord.destroy_all
House.destroy_all

## HOUSES  ##
houses = [{:name => "ATO"},
          {:name => "GDI"}]

house_instances = []
houses.each do |house|
    house_instances << House.create!(house)
end
ato, gdi = house_instances

## USERS ##
users = {gdi => [{:first_name => 'Giorgia', :last_name => 'Willits',
                   :phone_number => '7147884536', :email => 'gw@berkeley.edu',
                   :avatar => File.new("#{Rails.root}/app/assets/images/gige.jpg"),
                   :password => 'gw'},
                  {:first_name => 'Valeriya', :last_name => 'Imeshiva',
                   :phone_number => '+14444444444', :email => 'vi@berkeley.edu',
                   :avatar => File.new("#{Rails.root}/app/assets/images/val.jpg"),
                   :password => 'vi'},
                  {:first_name => 'Anne', :last_name => 'Zeng',
                   :phone_number => '7148759292', :email => 'az@berkeley.edu',
                   :avatar => File.new("#{Rails.root}/app/assets/images/anne.jpg"),
                   :password => 'az'},
                  {:first_name => 'Pauline', :last_name => 'Duprat',
                   :phone_number => '+14444444444', :email => 'pd@berkeley.edu',
                   :avatar => File.new("#{Rails.root}/app/assets/images/paul.jpg"),
                   :password => 'pd'},
                  {:first_name => 'Lauren', :last_name => 'Capelluto',
                   :phone_number => '+15555555555', :email => 'lc@berkeley.edu',
                   :avatar => File.new("#{Rails.root}/app/assets/images/yannie.jpg"),
                   :password => 'yy'} ],
         ato => [{:first_name => 'Eric', :last_name => 'Nelson',
                   :phone_number => '+11111111111', :email => 'en@berkeley.edu',
                   :password => 'en'},
                  {:first_name => 'Aran', :last_name => 'Bahl',
                   :phone_number => '+12222222222', :email => 'ab@berkeley.edu',
                   :password => 'ab'},
                  {:first_name => 'Shane', :last_name => 'Barrat',
                   :phone_number => '+13333333333', :email => 'sb@berkeley.edu',
                   :password => 'sb'}]}

user_instances = []
users.each do |house, user_hashes|
    user_hashes.each do |user|
        u = User.create!(user)
        u.house = house
        u.save
        user_instances << u
    end
end

gige = User.find_by_first_name("Giorgia")
val = User.find_by_first_name("Valeriya")
paul = User.find_by_first_name("Pauline")
anne = User.find_by_first_name("Anne")
lauren = User.find_by_first_name("Lauren")

## EXPENSES ##
expenses = [{:name => "Rent", :amount => "4600", :date => "June 1, 2016",
             :category => "Rent", :details => "June Rent",
            #  :deadline => "June 1, 2016", :paid_by => gige},
             :deadline => "2017-04-05 17:37:00", :paid_by => gige},
            {:name => "Toiletries", :amount => "10", :date => "July 10, 2016",
             :category => "Supplies", :details => "Toilet Paper and Such",
            #  :deadline => "July 31, 2016", :paid_by => paul},
             :deadline => "2016-08-23 21:57:00", :paid_by => anne},
            {:name => "Ramen", :amount => "24", :date => "July 11, 2016",
             :category => "Supplies", :details => "Amazon Ramen Subscription",
            #  :deadline => "August 21, 2016", :paid_by => lauren},
             :deadline => "2016-08-23 21:58:00", :paid_by => gige},
            {:name => "Paper Towels", :amount => "23.49", :date => "June 13, 2016",
             :category => "Supplies", :details => "Amazon Subscription",
            #  :deadline => "August 21, 2016", :paid_by => gige}]
             :deadline => "2016-08-23 21:59:00", :paid_by => val}]

expense_instances = []
expenses.each do |expense|
    expense_instances << Expense.create!(expense)
end
june_rent = Expense.find_by_details("June Rent")
amazon = Expense.find_by_details("Amazon Subscription")
toiletries = Expense.find_by_details("Toilet Paper and Such")
ramen = Expense.find_by_details("Amazon Ramen Subscription")

## CHARGES ##
charges = [{:completed => false, :amount => 1650.34, :expense => june_rent, :charged_to => anne},
           {:completed => true, :amount => 650, :expense => june_rent, :charged_to => paul},
           {:completed => true, :amount => 1100, :expense => june_rent, :charged_to => gige},
           {:completed => true, :amount => 1100, :expense => june_rent, :charged_to => val},
           {:completed => true, :amount => 1100, :expense => june_rent, :charged_to => lauren},

           {:completed => true, :amount => 6, :expense => ramen, :charged_to => gige},
           {:completed => true, :amount => 6, :expense => ramen, :charged_to => anne},
           {:completed => false, :amount => 6, :expense => ramen, :charged_to => paul},
           {:completed => false, :amount => 6, :expense => ramen, :charged_to => val},

           {:completed => false, :amount => 10, :expense => toiletries, :charged_to => gige},

           {:completed => true, :amount => 7.83, :expense => amazon, :charged_to => val},
           {:completed => true, :amount => 7.83, :expense => amazon, :charged_to => anne},
           {:completed => false, :amount => 7.83, :expense => amazon, :charged_to => lauren}]

charge_instances = []
charges.each do |charge|
    charge_instances << Charge.create!(charge)
end
