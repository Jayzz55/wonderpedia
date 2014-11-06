class ApplicationController < ActionController::Base
  include Pundit
  after_action :flash_discard
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def flash_discard
    # This will discontinue execution if Rails detects that the request is not
    # from an AJAX request, i.e. the header wont be added for normal requests
    return unless request.xhr?
   
    # Stops the flash appearing when you next refresh the page
    flash.discard
  end
 
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end


end
