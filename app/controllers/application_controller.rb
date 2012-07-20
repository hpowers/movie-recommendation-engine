class ApplicationController < ActionController::Base
  before_filter :remove_www!
  protect_from_forgery

  def remove_www!
    if Rails.env.production? and request.host[0..3] == "www."
      redirect_to "#{request.protocol}#{request.host_with_port[4..-1]}#{request.fullpath}", :status => 301
    end
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == USER_ID && password == PASSWORD
      end
    end

end
