class Appointment < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer
  has_many :pins
  has_many :consumers, :through => :pins

  attr_accessible :title, :description, :date, :time, :assigned_pin, :status

  after_create :send_message_to_consumers

  def is_open?
    return (self.status == "open")
  end

  def get_consumer_response
    # A random 4 digit numerical PIN will be created and sent to the Consumer User responding with "Y"
    # "You are tentatively confirmed, Please call [PracticePhone] and provide pin [XXXX]
  end

  protected

  def send_message_to_consumers
#    Consumer Users are alerted in batches of 10. There will be a 10 minute lag 
#    between notification sent to each 10 and if any one Consumer User repsonds 
#    with Y, the next 10 will not be notified.

#    "[PracticeName] has an open slot at X:XXP on MM/DD" Respond to "Y" to this 
#    text and we will send you a confirmation pin and the booking phone number! 
#    Slots go fast, so please confirm as soon as practical"

    # Instantiate a Twilio client
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    manager = self.manager
    manager_practice_name = manager.practice_name
    manager_practice_phone = manager.practice_phone

    appointment_date = self.date.strftime("%m/%d")
    appointment_time = self.time.strftime("%H:%M")

    # TODO: We need to batch this!!!
    self.manager.consumers.each do |consumer|
      message = "#{manager_practice_name} has an open slot at #{appointment_time} on #{appointment_date}." 
      message += " Respond to 'Y #{self.id}' to this text and we will send you a confirmation pin"
      message += " and the booking phone number! Slots go fast, so please confirm as soon as practical."

      # Create and send an SMS message. Message must be editable?
      logger.debug "New slot message..."
      logger.debug "From: #{manager_practice_phone}"
      logger.debug "To: #{consumer.phone_number}"
      logger.debug "Message: #{message}"

      sms = client.account.sms.messages.create(
        from: manager_practice_phone,
        to: consumer.phone_number,
        body: message
      )

      Message.create!(
        :sms_sid => sms.sid,
        :consumer_id => consumer_id,
        :manager_id => manager_id,
        :body => sms.body,
        :from => sms.from,
        :to => sms.to
      )
    end
  end

end

