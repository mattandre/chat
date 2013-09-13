class PagesController < ApplicationController

	#Filters
	skip_before_action :require_signed_in_user

  def home
  end

  def help
  end

  def about 
  end
end
