class ManagerController < ActionController::Base
  protect_from_forgery

  layout 'manager'

  def current_ability
    @current_ability ||= Ability.new(current_manager)
  end

end
