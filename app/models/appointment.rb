class Appointment < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer
  has_many :pins
  has_many :consumers, :through => :pins

  attr_accessible :title, :description, :date, :time
end

