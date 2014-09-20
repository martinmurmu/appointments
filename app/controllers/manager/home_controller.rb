class Manager::HomeController < ManagerController

  def index
    if current_manager
      # get waitlister and appointments count by day
      @date_list = []
      date = Date.today
      @waitlist_days = []
      @appointments_days = []
      for i in 0..GlobalConstants::GRAPH_DAYS
        @date_list.push date
        # waitlister
        waitlist_count = current_manager.rolable.consumers.count(:conditions=>["DATE(consumers.created_at) = ?", date])
        @waitlist_days.push waitlist_count
        # appointment
        appointment_count = current_manager.rolable.appointments.count(:conditions =>["DATE(appointments.created_at) = ?", date])
        @appointments_days.push appointment_count
        date -= 1
      end
      # appointment count
      @appointments_filled_count = current_manager.rolable.appointments.where(:status => Appointment::FILLED).count
      @appointments_active_count = current_manager.rolable.appointments.where(:status => Appointment::BROADCASTED).count
      @appointments_all_count = current_manager.rolable.appointments.count
      
      # consumer count
      @waitlists_filled_count = current_manager.rolable.consumers.where(:status => Consumer::FILLED).count
      @waitlists_active_count = current_manager.rolable.consumers.where(:status => Consumer::WAITING).count
      @waitlists_all_count = current_manager.rolable.consumers.count
      
      # new appointment
      @appointment = Appointment.new
      # new consumer
      @consumer = Consumer.new
    end
  end
  
  # Ajax request for creating appointment at home
  def appointments
    @appointment = Appointment.new(params[:appointment])
    str_datetime = params[:datetime].to_datetime
    # @appointment.date = DateTime.strptime(params[:appointment][:datetime], "%m-%d-%Y")
    @appointment.date = str_datetime
    @appointment.time = str_datetime
    @appointment.manager = current_manager.rolable

    respond_to do |format|
      if @appointment.save
        @notice = "Well done! You have broadcasted a message to your Waitlist." 
      else
        @notice = "Not created! Please retry."
      end
      format.js
    end
  end
  
  def consumer
    @consumer = Consumer.where(params[:consumer]).create
    @consumer.phone_number = params[:consumer][:phone_number].delete(" ")

    respond_to do |format|
      if @consumer.save
        @consumer.tags.create(
          :manager_id => current_manager.rolable.id,
          :tags => params[:tags]
        )
        @notice = "Well done! This patient has been waitlisted and will receive your broadcasts."
      else
        @notice = "Not created! Please retry."
      end
      format.js
    end
  end
end
