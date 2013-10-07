class Manager < ActiveRecord::Base

  has_one :user, :as => :rolable

  has_many :appointments
  has_many :pins, :through => :appointments
  has_many :consumers, :through => :pins

  attr_accessible :practice_name, :practice_phone, :practice_address

end
