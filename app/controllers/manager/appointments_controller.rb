class Manager::AppointmentsController < ManagerController

  load_and_authorize_resource

  # GET /manager/appointments
  # GET /manager/appointments.json
  def index
    @appointments = current_manager.rolable.appointments

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
    @appointment.manager = current_manager.rolable

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to manager_appointment_path(@appointment), notice: 'Appointment was successfully created.' }
        format.json { render json: manager_appointment_path(@appointment), status: :created, location: @appointment }
      else
        format.html { render action: "new" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/appointments/1
  # PUT /manager/appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        format.html { redirect_to manager_appointment_path(@appointment), notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/appointments/1
  # DELETE /manager/appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to manager_appointments_path }
      format.json { head :no_content }
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
end
