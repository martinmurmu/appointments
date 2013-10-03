class Manager < ActiveRecord::Base

  has_one :user
  has_many :appointments
  has_many :consumers, :through => :appointments

  attr_accessible :practice_name, :practice_phone, :practice_address

end
