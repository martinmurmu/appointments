class Consumer < ActiveRecord::Base

  has_many :pins
  has_many :appointments, :through => :pins
  has_many :managers, :through => :appointments

  attr_accessible :phone_number

end

