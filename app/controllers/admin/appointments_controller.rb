class Admin::AppointmentsController < AdminController

  # GET /admin/appointments
  # GET /admin/appointments.json
  def index
    @appointments = Appointment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /admin/appointments/1
  # GET /admin/appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /admin/ppointments/new
  # GET /admin/appointments/new.json
  def new
    @appointment = Appointment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /admin/appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
  end

  # POST /admin/appointments
  # POST /admin/appointments.json
  def create
    @appointment = Appointment.new(params[:appointment])

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to admin_appointment_path(@appointment), notice: 'Appointment was successfully created.' }
        format.json { render json: admin_appointment_path(@appointment), status: :created, location: @appointment }
      else
        format.html { render action: "new" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/appointments/1
  # PUT /admin/appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        format.html { redirect_to admin_appointment_path(@appointment), notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/appointments/1
  # DELETE /admin/appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to admin_appointments_path }
      format.json { head :no_content }
    end
  end
end
