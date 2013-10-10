class Manager::ProfilesController < ManagerController

  # GET /manager/profile
  def edit
    @manager = current_manager.rolable
  end

  # PUT /manager/profile
  # PUT /manager/profile
  def update
    @manager = current_manager.rolable

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to manager_root_path, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

end
