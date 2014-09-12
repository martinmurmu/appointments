class Consumer < ActiveRecord::Base

  has_many :tags
  has_many :pins
  has_many :appointments, :through => :pins
  has_many :managers, :through => :appointments
  has_many :managers, :through => :tags

  attr_accessible :phone_number, :enabled

  validates :phone_number, :presence => true,
                           :length => { :minimum => 10, :maximum => 15 }
  
  # define attributes and accessors
  attr_accessor :user_name
  
  def to_s
    phone_number
  end

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end  
end

