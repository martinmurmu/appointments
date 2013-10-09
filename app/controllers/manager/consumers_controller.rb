class Manager::ConsumersController < ManagerController

  # GET /manager/consumers
  # GET /manager/consumers.json
  def index
    if params[:appointment_id]
      appointment = Appointment.find(params[:appointment_id])
      @consumers = appointment.consumers
    else
      @consumers = current_manager.rolable.consumers
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumers }
    end
  end

  # GET /manager/consumers/1
  # GET /manager/consumers/1.json
  def show
    @consumer = Consumer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consumer }
    end
  end

  # GET /manager/consumers/new
  # GET /manager/consumers/new.json
  def new
    if params[:appointment_id]
      @appointment = Appointment.find(params[:appointment_id])
    end

    @consumer = Consumer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consumer }
    end
  end

  # GET /manager/consumers/1/edit
  def edit
    @consumer = Consumer.find(params[:id])
  end

  # POST /manager/consumers
  # POST /manager/consumers.json
  # TODO Check if this must be done in another action
  def create
    @consumer = Consumer.where(params[:consumer]).first_or_create

    if params[:appointment_id]
      appointment = Appointment.find(params[:appointment_id])
      pin = Pin.new
      pin.appointment = appointment
      pin.consumer = @consumer
    end

    respond_to do |format|
      if @consumer.save
        if !pin.nil?
          pin.save
        end
        format.html { redirect_to manager_consumer_path(@consumer), notice: 'Consumer was successfully created.' }
        format.json { render json: manager_consumer_path(@consumer), status: :created, location: @consumer }
      else
        format.html { render action: "new" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/consumers/1
  # PUT /manager/consumers/1.json
  def update
    @consumer = Consumer.find(params[:id])

    respond_to do |format|
      if @consumer.update_attributes(params[:consumer])
        format.html { redirect_to manager_consumer_path(@consumer), notice: 'Consumer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/consumers/1
  # DELETE /manager/consumers/1.json
  def destroy
    @consumer = Consumer.find(params[:id])
    @consumer.destroy

    respond_to do |format|
      format.html { redirect_to manager_consumers_path }
      format.json { head :no_content }
    end
  end
end
