class Appointment < ActiveRecord::Base

  attr_accessible :title, :description, :date, :time
end
