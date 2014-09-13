class Manager::HomeController < ManagerController

  def index
    if current_manager
      # waitlister count
      @consumers_count = current_manager.rolable.consumers.count
      # get waitlister and appointments count by day
      date = Date.today
      @waitlister_days = []
      @appointments_days = []
      for i in 0..GlobalConstants::GRAPH_DAYS
        @waitlister_days.push current_manager.rolable.consumers.count(:conditions=>["DATE(consumers.created_at) = ?", date])
        #@waitlister_days.push current_manager.rolable.consumers.count
        @appointments_days.push current_manager.rolable.appointments.count(:conditions =>["status=:status and DATE(appointments.created_at)=:date", {status:"Filled", date:date}])
        date -= 1
      end
      # appointment count
      @appointments_filled_count = current_manager.rolable.appointments.where(:status => 'Filled').count
      
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
