class Appointment < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer
  has_many :pins
  has_many :consumers, :through => :pins

  attr_accessible :manager_id, :title, :description, :date, :time, :assigned_pin, :status, :enabled

  after_create :send_message_to_consumers

  validates :date, :time, :presence => true

  # status
  BROADCASTED = "Broadcasted"
  FILLED = "Filled"
  CANCELED = "Canceled"

  def to_s
    return self.get_datetime
  end

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end 

  def is_broadcasted?
    return (self.status == BROADCASTED)
  end

def is_filled?
    return (self.status == FILLED)
  end

  def is_canceled?
    return (self.status == CANCELED)
  end

  def set_broadcasted
    if self.is_filled?
      # self.pins.where(:pin => apt.assigned_pin)[0].delete
      self.assigned_pin = ""
    end

    self.status = BROADCASTED
    if self.save
      self.send_message_to_consumers
    end
  end

  def set_filled
    if self.is_broadcasted?
      self.status = FILLED
      self.save
    end
  end

  def set_canceled
    if self.is_broadcasted?
      self.status = CANCELED
      self.save
    end
  end

  def get_consumer_response
    # A random 4 digit numerical PIN will be created and sent to the Consumer User responding with "Y"
    # "You are tentatively confirmed, Please call [PracticePhone] and provide pin [XXXX]
  end

  def get_datetime
    if (self.new_record?)
      return ""
    end

    datetime = DateTime.new(self.date.year, self.date.month, self.date.day, 
      self.time.hour, self.time.min, self.time.sec)

    # Datetime picker format: "January 2, 2014 - 4:34PM"
    return datetime.strftime("%B %e, %Y - %l:%M %p")
  end

  def get_time
    return self.time.strftime("%l:%M %p") #4:34PM
  end

  def get_date
    return self.date.strftime("%B %e, %Y") #January 2, 2014
  end

  def send_message_to_consumers
    logger.debug "Called send_message_to_consumers..."
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

    appointment_date = self.get_date
    appointment_time = self.get_time

    enabled_consumers = self.manager.consumers.where(:enabled => true)

    logger.debug "Run broadcast!"

    count = 0

    enabled_consumers.each do |consumer|
      count += 1
      # Old message.
      # message = "#{manager_practice_name} has an open slot at #{appointment_time} on #{appointment_date}." 
      # message += " Respond with 'Y #{self.id}' to this text and we will send you a confirmation pin"
      # message += " and the booking phone number! Slots go fast, so please confirm as soon as practical."

      message = "#{manager_practice_name} has an open appt. at #{appointment_time} on #{appointment_date}."
      message += " Reply 'Y #{self.id}' to this text & we'll send a confirmation & booking! Slots go fast, please reply asap."

      # Create and send an SMS message. Message must be editable?
      logger.debug "New slot message..."
      logger.debug "From: #{TWILIO_CONFIG['from']}"
      logger.debug "To: #{consumer.phone_number}"
      logger.debug "Message: #{message}"

      # Send to 10 consumers then wait for 10 minutes
      if (count == 1)
        sleep(5)
        count = 0
      end

      # sms = client.account.sms.messages.create(
      #   from: TWILIO_CONFIG['from'],
      #   to: consumer.phone_number,
      #   body: message
      # )

      # Message.create!(
      #   :sms_sid => sms.sid,
      #   :consumer => consumer,
      #   :manager => manager,
      #   :body => sms.body,
      #   :from => sms.from,
      #   :to => sms.to
      # )
    end
  end

  handle_asynchronously :send_message_to_consumers, :run_at => Proc.new { Time.zone.now }
end

