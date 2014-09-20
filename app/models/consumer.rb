class Consumer < ActiveRecord::Base

  has_many :tags
  has_many :pins
  has_many :appointments, :through => :pins
  has_many :managers, :through => :appointments
  has_many :managers, :through => :tags

  attr_accessible :phone_number, :name, :status, :enabled

  validates :phone_number, :presence => true,
                           :length => { :minimum => 10, :maximum => 15 }
  
  # define attributes and accessors
  attr_accessor :user_name
  
  # status
  WAITING = "Waiting"
  FILLED = "Filled"
  CANCELED = "Canceled"
  
  def to_s
    phone_number
  end

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end
  
  def is_waiting?
    return (self.status == WAITING)
  end

  def is_filled?
    return (self.status == FILLED)
  end

  def is_canceled?
    return (self.status == CANCELED)
  end
  
  #search
  def self.search(search)
    if search
      find(:all, :conditions => ['phone LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end  
end

