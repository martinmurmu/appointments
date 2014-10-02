class Manager::RegistrationsController < Devise::RegistrationsController

  layout 'manager'
  
  def new
    super
  end

  # POST
  def create
    logger.debug "Manager's registration..."
    logger.debug params

    build_resource(params[:manager])

    # Creates a new Manager related to this User
    manager = Manager.new(
      :name => params[:name],
      :phone => params[:phone]
    )
    
    if manager.save
      resource.rolable = manager
    end

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    super
  end

  def after_update_path_for(resource)
    manager_root_path
  end

end
