class Consumer < ActiveRecord::Base

  has_many :tags
  has_many :pins
  has_many :appointments, :through => :pins
  has_many :managers, :through => :appointments
  has_many :managers, :through => :tags

  attr_accessible :phone_number
end

