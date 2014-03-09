class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This is a silly hack to store the strong parameters compatible
  # params back in params, if the controller has a resource_params
  # method.
  # See CanCan Issue #835: https://github.com/ryanb/cancan/issues/835
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
end
