class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)

    stored_location_for(resource) ||
      if resource.is_a?(Admin)
        admin_dashboard_path
      else
        manager_root_path(resource)
      end

#    if !current_manager.nil?
#      home_path = "/manager"
#    end
#    respond_to?(home_path, true) ? send(root_path) : home_path
  end

  def after_sign_out_path_for(resource)
    root_path
#    if !current_manager.nil?
#      home_path = "/manager/sign_in"
#    end
#    respond_to?(home_path, true) ? send(root_path) : home_path
  end

end
