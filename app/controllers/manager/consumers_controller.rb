class Manager::ConsumersController < ManagerController
  helper_method :sort_column, :sort_direction
  
  load_and_authorize_resource

  # GET /manager/consumers
  # GET /manager/consumers.json
  def index
    logger.debug current_manager

    if params[:appointment_id]
      appointment = Appointment.find(params[:appointment_id])
      @consumers = appointment.consumers.
        where(["name LIKE ? OR phone_number LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%"]).order(sort_column + " " + sort_direction)
    else
      @consumers = current_manager.rolable.consumers.
        where(["name LIKE ? OR phone_number LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%"]).order(sort_column + " " + sort_direction)
    end
    
    @consumers = @consumers.paginate(page: params[:page], per_page: GlobalConstants::PAGE_LIST_NUM)
    @consumer = Consumer.new
    respond_to do |format|
      format.html
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
    @consumer = Consumer.where(params[:consumer]).create
    @consumer.phone_number = params[:consumer][:phone_number].delete(" ")

    respond_to do |format|
      if @consumer.save
        @consumer.tags.create(
          :manager_id => current_manager.rolable.id,
          :tags => params[:tags]
        )

        logger.debug @consumer
        format.html { redirect_to manager_consumers_path, notice: 'Well done! This patient has been waitlisted and will receive your broadcasts.' }
        format.json { render json: manager_consumers_path, status: :created, location: @consumer }
      else
        errors = ""
        @consumer.errors.full_messages.each do |msg|
          errors.concat("<br>")
          errors.concat(msg)
        end
        format.html { redirect_to manager_consumers_path, alert: errors }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/consumers/1
  # PUT /manager/consumers/1.json
  def update
    @consumer = Consumer.find(params[:id])
    tag = @consumer.tags.where(:manager_id => current_manager.rolable.id).first
    tag.tags = params[:tags]
    respond_to do |format|
      if @consumer.update_attributes(params[:consumer])
        tag.save
        format.html { redirect_to manager_consumer_path(@consumer), notice: 'Consumer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/consumers/1/enable
  def enable
    consumer = Consumer.find(params[:id])
    consumer.enable
    respond_to do |format|
      if consumer.save
        format.html { redirect_to manager_consumers_path, notice: 'Consumer was successfully enabled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_consumers_path, notice: 'Error trying to enable the Consumer.' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/consumers/1
  # DELETE /manager/consumers/1.json
  def destroy
    @consumer = Consumer.find(params[:id])
    @consumer.disable

    respond_to do |format|
      if @consumer.save
        format.html { redirect_to manager_consumers_path, notice: 'Consumer was successfully removed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_consumers_path, notice: 'Error trying to disable the Consumer' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def sort_column
    Consumer.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
