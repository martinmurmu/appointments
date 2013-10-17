class Manager < ActiveRecord::Base

  has_one :user, :as => :rolable

  has_many :appointments
  has_many :tags
  has_many :pins, :through => :appointments
  has_many :consumers, :through => :tags

  attr_accessible :practice_name, :practice_phone, :practice_address

  validates :practice_name, :practice_phone, :practice_address, :presence => true

# This must be a rake task?
#  After each 72 hours... "You are still on the [PracticeName] waitlist. 
#  If you'd like to be removed please reply "X" to this message and we remove 
#  you from the waitlist.

#  If X, "No worries, you are off the list."

  def send_consumers_reminder
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    # TODO: We need to batch this too?!
    self.consumers.each do |consumer|
      message = "You are still on the #{self.practice_name} waitlist."
      message += " If you'd like to be removed please reply 'X #{self.id}' to this message"
      message += " and we remove you from the waitlist."

      # Create and send an SMS message. Message must be editable?
      logger.debug "Remainder message..."
      logger.debug "From: #{self.practice_phone}"
      logger.debug "To: #{consumer.phone_number}"
      logger.debug "Message: #{message}"

      #    client.account.sms.messages.create(
      #      from: manager_practice_phone,
      #      to: consumer.phone_number,
      #      body: message
      #    )
    end
  end
end
