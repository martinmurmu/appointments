class Message < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer

  attr_accessible :sms_sid, :from, :to, :body

end
