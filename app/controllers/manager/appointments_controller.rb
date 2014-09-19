class Manager::AppointmentsController < ManagerController
  helper_method :sort_column, :sort_direction
  
  load_and_authorize_resource
  
  # GET /manager/appointments
  # GET /manager/appointments.json
  def index
    @appointments = current_manager.rolable.appointments.search(params[:search])
    @appointments = Appointment.order(sort_column + " " + sort_direction)
    @appointments = Appointment.paginate(page: params[:page], per_page: GlobalConstants::PAGE_LIST_NUM)
    @appointment = Appointment.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /manager/appointments/1
  # GET /manager/appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /manager/appointments/new
  # GET /manager/appointments/new.json
  def new
    @appointment = Appointment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /manager/appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
  end

  # POST /manager/appointments
  # POST /manager/appointments.json
  def create
    @appointment = Appointment.new(params[:appointment])
    str_datetime = params[:datetime].to_datetime
    # @appointment.date = DateTime.strptime(params[:appointment][:datetime], "%m-%d-%Y")
    @appointment.date = str_datetime
    @appointment.time = str_datetime
    @appointment.manager = current_manager.rolable

    notice = "Well done! You have broadcasted a message to your Waitlist. You'll get a phone call from the first patient to respond!"
    
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to manager_appointments_path, notice: notice }
        format.json { render json: manager_appointment_path(@appointment), status: :created, location: @appointment }
      else
        errors = ""
        @appointment.errors.full_messages.each do |msg|
          errors.concat("<br>")
          errors.concat(msg)
        end
        format.html { redirect_to manager_appointments_path, alert: errors }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/appointments/1
  # PUT /manager/appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])
    str_datetime = params[:datetime].to_datetime
    # @appointment.date = DateTime.strptime(params[:appointment][:datetime], "%m-%d-%Y")
    @appointment.date = str_datetime
    @appointment.time = str_datetime
    @appointment.description = params[:appointment][:description]

    respond_to do |format|
      if @appointment.save()
        format.html { redirect_to manager_appointment_path(@appointment), notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/appointments/1/enable
  def enable
    appointment = Appointment.find(params[:id])
    appointment.enable
    appointment.set_broadcasted

    respond_to do |format|
      if appointment.save
        format.html { redirect_to manager_appointments_path, notice: 'The slot was successfully enabled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_appointments_path, alert: 'Error trying to enable the slot.' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/appointments/1
  # DELETE /manager/appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])

    if @appointment.is_filled?
      respond_to do |format|
        format.html { redirect_to manager_consumers_path, alert: "You can't cancel the slot because it is already filled." }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
    
    @appointment.set_canceled

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to manager_appointments_path, notice: 'The slot was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_consumers_path, alert: 'Error trying to cancel the slot.' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /manager/appointments/:id/consumers
  # GET /manager/appointments/:id/consumers.json
  def consumers
    @consumer = Consumer.new
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
#      format.json { render json: @appointment }
    end
  end

  # POST /manager/appointments/:id/consumers
  # POST /manager/appointments/:id/consumers.json
  def addConsumer
    # get or create new consumer
    consumer = Consumer.where(:phone_number => params[:phone_number]).take || Consumer.create(params[:consumer])

    @appointment = Appointment.find(params[:id])

    pin = Pin.new
    pin.appointment = @appointment
    pin.consumer = consumer

    respond_to do |format|
      if consumer.save
        format.html { redirect_to manager_appointment_consumers_path(@appointment), notice: 'Consumer was successfully added.' }
        format.json { render json: manager_appointment_consumers_path(@appointment), status: :ok, location: @appointment }
      else
        format.html { render action: "addConsumer" }
        format.json { render json: consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/appointments/:id/rebroadcast
  def rebroadcast
    appointment = Appointment.find(params[:id])
    
    respond_to do |format|
      if !appointment.is_canceled?
        # This method calls send_message_to_consumers
        appointment.set_broadcasted
        format.html { redirect_to manager_appointments_path, notice: "Rebroadcast done!" }
      else
        format.html { redirect_to manager_appointments_path, alert: "You only can rebroadcast non filled slots!" }
      end
    end
  end
  
  private
  
  def sort_column
    Appointment.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
