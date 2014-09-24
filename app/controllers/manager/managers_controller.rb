class Manager::ManagersController < ManagerController
  helper_method :sort_column, :sort_direction
  
  load_and_authorize_resource

  # GET /manager/managers
  # GET /manager/managers.json
  def index
    logger.debug current_manager

    @managers = Manager.where(["practice_name LIKE ?", "%#{params[:search]}%"]).order(sort_column + " " + sort_direction)
    
    @managers = @managers.paginate(page: params[:page], per_page: GlobalConstants::PAGE_LIST_NUM)
    @manager = Manager.new
    respond_to do |format|
      format.html
      format.json { render json: @managers }
    end
  end

  # GET /manager/managers/1
  # GET /manager/managers/1.json
  def show
    @manager = Manager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /manager/managers/new
  # GET /manager/managers/new.json
  def new
    @manager = Manager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /manager/managers/1/edit
  def edit
    @manager = Manager.find(params[:id])
  end

  # POST /manager/managers
  # POST /manager/managers.json
  # TODO Check if this must be done in another action
  def create
    @manager = Manager.where(params[:manager]).create
    @manager.practice_name = params[:manager][:practice_name]
    @manager.practice_address = params[:manager][:practice_address].delete(" ")
    @manager.practice_phone = params[:manager][:practice_phone].delete(" ")

    respond_to do |format|
      if @manager.save
        format.html { redirect_to manager_managers_path, notice: 'Well done! This patient has been waitlisted and will receive your broadcasts.' }
        format.json { render json: manager_managers_path, status: :created, location: @manager }
      else
        errors = ""
        @manager.errors.full_messages.each do |msg|
          errors.concat("<br>")
          errors.concat(msg)
        end
        format.html { redirect_to manager_managers_path, alert: errors }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/managers/1
  # PUT /manager/managers/1.json
  def update
    @manager = Manager.find(params[:id])
    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to manager_manager_path(@manager), notice: 'manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/managers/1/enable
  def enable
    manager = Manager.find(params[:id])
    manager.enable
    respond_to do |format|
      if manager.save
        format.html { redirect_to manager_managers_path, notice: 'manager was successfully enabled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_managers_path, notice: 'Error trying to enable the manager.' }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/managers/1
  # DELETE /manager/managers/1.json
  def destroy
    @manager = Manager.find(params[:id])
    @manager.disable

    respond_to do |format|
      if @manager.save
        format.html { redirect_to manager_managers_path, notice: 'manager was successfully removed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to manager_managers_path, notice: 'Error trying to disable the manager' }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def sort_column
    Manager.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
