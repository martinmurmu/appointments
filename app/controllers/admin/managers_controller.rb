class Admin::ManagersController < AdminController

  # GET /admin/managers
  # GET /admin/managers.json
  def index
    @managers = Manager.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @managers }
    end
  end


  # GET /admin/managers/1
  # GET /admin/managers/1.json
  def show
    @manager = Manager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /admin/managers/new
  # GET /admin/managers/new.json
  def new
    @manager = Manager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /admin/managers/1/edit
  def edit
    @manager = Manager.find(params[:id])
  end

  # POST /admin/managers
  # POST /admin/managers.json
  def create
    @manager = Manager.new(params[:manager])

    respond_to do |format|
      if @manager.save
        format.html { redirect_to admin_manager_path(@manager), notice: 'Manager was successfully created.' }
        format.json { render json: admin_manager_path(@manager), status: :created, location: @manager }
      else
        format.html { render action: "new" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/managers/1
  # PUT /admin/managers/1.json
  def update
    @manager = Manager.find(params[:id])

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to admin_manager_path(@manager), notice: 'Manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

#  # DELETE /appointments/1
#  # DELETE /appointments/1.json
#  def destroy
##    @appointment = Appointment.find(params[:id])
#    @appointment.destroy

#    respond_to do |format|
#      format.html { redirect_to appointments_url }
#      format.json { head :no_content }
#    end
#  end
end
