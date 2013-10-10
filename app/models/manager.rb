class Manager < ActiveRecord::Base

  has_one :user, :as => :rolable

  has_many :appointments
  has_many :tags
  has_many :pins, :through => :appointments
  has_many :consumers, :through => :pins
  has_many :consumers, :through => :tags

  attr_accessible :practice_name, :practice_phone, :practice_address

end
