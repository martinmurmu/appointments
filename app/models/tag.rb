class Tag < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer

  after_create :send_welcome_message

  protected

  def send_welcome_message
    
    # Instantiate a Twilio client
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    message = "Congrats, you are on #{self.manager.practice_name} waitlist!"
    message += " You'll get a text with appt. times as soon as they become available!"

    # Create and send an SMS message. Message must be editable?
    logger.debug "Welcome message..."
    logger.debug "From: #{self.manager.practice_phone}"
    logger.debug "To: #{self.consumer.phone_number}"
    logger.debug "Message: #{message}"

    client.account.sms.messages.create(
      from: self.manager.practice_phone,
      to: self.consumer.phone_number,
      body: message
    )

    Message.create!(
      :sms_sid => sms.sid,
      :consumer_id => self.consumer.id,
      :manager_id => self.manager.id,
      :body => sms.body,
      :from => sms.from,
      :to => sms.to
    )
  end
end
