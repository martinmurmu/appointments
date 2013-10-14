class ReceiverController < ActionController::Base

  def parse
    # Mapped to http://localhost:3000/sms in the routes.rb file
    
    message_body = params["Body"]
    from_number = params["From"]
 
    logger.debug from_number
    logger.debug message_body

    # Example: "Y 123"
    parsedMessage = message_body.split(" ") # ["Y", "123"]

    message = ""

    case parsedMessage[0]
    when "Y"
      # Get data
      appointment = Appointment.find(parsedMessage[1])

      manager = appointment.manager
      manager_phone_number = manager.practice_phone

      consumer = Consumer.where(:phone_number => from_number).first

      logger.debug "Appointment ID #{appointment.id}, Consumer ID #{consumer.id}"

      pin = Pin.new
      pin.appointment = appointment
      pin.consumer = consumer

      if pin.save
        if appointment.is_open?
          appointment.update_attributes!(:status => "closed", :assigned_pin => pin.pin)
          message = "You are tentatively confirmed. Please call #{manager_phone_number} and provide pin #{pin.pin}"
        else
          message = "Sorry! You did not get the slot. The good news is the waitlist is moving!"
          message += " You can stay on the list or reply 'X #{manager.id}' to be removed from the list."
        end
      end
    when "X"
      manager = Manager.find(parsedMessage[1])
      consumer = Consumer.where(:phone_number => from_number).first

      tag = Tag.where(:manager_id => manager.id, :consumer_id => consumer.id).first
      #tag.destroy

      message = "No worries, you are off the list."
    end

    # build up a response
    response = Twilio::TwiML::Response.new do |r|
      r.Sms message
    end

    # print the result
    logger.debug "Response: #{response.text}"

    render :xml => response.text
  end

end
