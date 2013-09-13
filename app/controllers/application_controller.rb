class ApplicationController < ActionController::Base
  
  #Includes
  include SessionsHelper

  #Filters
  before_action :require_signed_in_user

	protect_from_forgery

end