class Consumer < ActiveRecord::Base

  has_many :appointments
  has_many :managers, :through => :appointments

  attr_accessible :phone_number

end
