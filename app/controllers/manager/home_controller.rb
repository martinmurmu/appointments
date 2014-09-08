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
end
