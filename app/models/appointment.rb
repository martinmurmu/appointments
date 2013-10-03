class Appointment < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer

  attr_accessible :title, :description, :date, :time
end
