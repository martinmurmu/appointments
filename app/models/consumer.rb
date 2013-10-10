class Consumer < ActiveRecord::Base

  has_many :tags
  has_many :pins
  has_many :appointments, :through => :pins
  has_many :managers, :through => :appointments
  has_many :managers, :through => :tags

  attr_accessible :phone_number

  after_create :send_welcome_sms

  def send_welcome_sms
    # Instantiate a Twilio client
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    # Create and send an SMS message
    client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: self.phone_number,
      body: "Testing new consumer creation."
    )
  end
end

