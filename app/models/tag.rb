class Tag < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer

  attr_accessible :tags, :manager_id

  after_create :send_welcome_message

  protected

  def send_welcome_message
    
    # Instantiate a Twilio client
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    message = "Congrats, you are on #{self.manager.name} waitlist!"
    message += " You'll get a text with appt. times as soon as they become available!"

    # Create and send an SMS message. Message must be editable?
    logger.debug "Welcome message..."
    logger.debug "From: #{TWILIO_CONFIG['from']}"
    logger.debug "To: #{self.consumer.phone_number}"
    logger.debug "Message: #{message}"

    return 
    sms = client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: self.consumer.phone_number,
      body: message
    )

    Message.create!(
      :sms_sid => sms.sid,
      :consumer => self.consumer,
      :manager => self.manager,
      :body => sms.body,
      :from => sms.from,
      :to => sms.to
    )
  end
end
