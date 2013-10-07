class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    if !current_admin.nil?
      home_path = "/admin"
    elsif !current_manager.nil?
      home_path = "/manager"
    end

    respond_to?(home_path, true) ? send(root_path) : home_path
  end

  def after_sign_out_path_for(resource_or_scope)
    if !current_admin.nil?
      home_path = "/admin/sign_in"
    elsif !current_manager.nil?
      home_path = "/manager/sign_in"
    end

    respond_to?(home_path, true) ? send(root_path) : home_path
  end

end
