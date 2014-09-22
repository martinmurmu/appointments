class Manager::HomeController < ManagerController

  def index
    if current_manager
      # get waitlister and appointments count by day
      @date_list = []
      date = Date.today - GlobalConstants::GRAPH_DAYS
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
        date += 1
      end
      # appointment count
      #@appointments_filled_count = current_manager.rolable.appointments.where(:status => Appointment::FILLED).count
      #@appointments_active_count = current_manager.rolable.appointments.where(:status => Appointment::BROADCASTED).count
      @appointments_all_count = current_manager.rolable.appointments.count
      
      # consumer count
      #@waitlists_filled_count = current_manager.rolable.consumers.where(:status => Consumer::FILLED).count
      #@waitlists_active_count = current_manager.rolable.consumers.where(:status => Consumer::WAITING).count
      @waitlists_all_count = current_manager.rolable.consumers.count
      
      # config date labels
      percent = GlobalConstants::GRAPH_WIDTH / (GlobalConstants::GRAPH_DAYS + 1)
      @date_label = ''
      @date_list.each do |adate|
        @date_label += '<label style="width:'+percent.to_s+'%">' + adate.mon.to_s + '/'+ adate.mday.to_s + '</label>'
      end
      
      # json data for calendar
      @calendar_data = appointmentsbydate(Date.today)
      p @calendar_data.to_json
      
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
  
  # Ajax request for creating waitlist at home
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
  
  # Ajax request for counting waitlist
  def countwaitlist
    status = params[:status]
    # consumer count
    @waitlists_count = 0
    if status == GlobalConstants::ALL
      @waitlists_count = current_manager.rolable.consumers.count
    elsif status == GlobalConstants::ACTIVE
      @waitlists_count = current_manager.rolable.consumers.where(:status => Consumer::WAITING).count
    elsif status == GlobalConstants::FILLED
      @waitlists_count = current_manager.rolable.consumers.where(:status => Consumer::FILLED).count
    end
    
    # waitlist days count
    @date_list = []
    date = Date.today
    @waitlist_days = []
    for i in 0..GlobalConstants::GRAPH_DAYS
      @date_list.push date
      # waitlister
      if status == GlobalConstants::ALL
        day_count = current_manager.rolable.consumers.count(:conditions=>["DATE(consumers.created_at)=?", date])
      elsif status == GlobalConstants::ACTIVE
        day_count = current_manager.rolable.consumers.count(:conditions=>["status=? AND DATE(consumers.created_at)=?", Consumer::WAITING, date])
      elsif status == GlobalConstants::FILLED
        day_count = current_manager.rolable.consumers.count(:conditions=>["status=? AND DATE(consumers.created_at)=?", Consumer::FILLED, date])
      end
      @waitlist_days.push day_count
      date -= 1
    end
    @waitlist = {:count => @waitlists_count, :days => @waitlist_days}
    respond_to do |format|
      format.js {}
      format.json {render json: @waitlist}
    end
  end
  
  # Ajax request for counting appointment
  def countappointment
    status = params[:status]
    # consumer count
    @appointments_count = 0
    if status == GlobalConstants::ALL
      @appointments_count = current_manager.rolable.appointments.count
    elsif status == GlobalConstants::ACTIVE
      @appointments_count = current_manager.rolable.appointments.where(:status => Appointment::BROADCASTED).count
    elsif status == GlobalConstants::FILLED
      @appointments_count = current_manager.rolable.appointments.where(:status => Appointment::FILLED).count
    end
    
    # waitlist days count
    @date_list = []
    date = Date.today
    @appointment_days = []
    for i in 0..GlobalConstants::GRAPH_DAYS
      @date_list.push date
      # appointment
      if status == GlobalConstants::ALL
        day_count = current_manager.rolable.appointments.count(:conditions=>["DATE(appointments.created_at)=?", date])
      elsif status == GlobalConstants::ACTIVE
        day_count = current_manager.rolable.appointments.count(:conditions=>["status=? AND DATE(appointments.created_at)=?", Appointment::BROADCASTED, date])
      elsif status == GlobalConstants::FILLED
        day_count = current_manager.rolable.appointments.count(:conditions=>["status=? AND DATE(appointments.created_at)=?", Appointment::FILLED, date])
      end
      @appointment_days.push day_count
      date -= 1
    end
    @appointment = {:count => @appointments_count, :days => @appointment_days}
    respond_to do |format|
      format.js {}
      format.json {render json: @appointment}
    end
  end
  
  private
  
  # get appointments
  def appointmentsbydate(dipdate)
    
    start_date = dipdate.at_beginning_of_month 
    end_date = dipdate.at_end_of_month  
    appointments = current_manager.rolable.appointments(:conditions=>
      ["status=? AND DATE(appointments.date)>=? AND DATE(appointments.date)<=?", Appointment::BROADCASTED, start_date, end_date])
    
    dip_json = []
    app = {}
    appointments.each do |appointment|
      # main infomations
      app[:title] = appointment.description
      app[:start] = appointment.date
      # display infomations
      app[:id] = appointment.id
      app[:ddate] = appointment.get_date
      app[:time] = appointment.get_time
      app[:comments] = appointment.description
      app[:status] = appointment.status
      app[:pin] = appointment.assigned_pin
      dip_json.push app
    end
    
    dip_json
  end
end
