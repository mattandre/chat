module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    if !user.sign_in(remember_token, request.remote_ip)
    	errors = ""
    	user.errors.full_messages.each do |msg|
    		errors += " " + msg + " "
    	end
		cookies[:error] = errors
    end
    self.current_user = user
  end

  def signed_in?
    current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    session.delete(:return_to)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token  = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token, ip: request.remote_ip)
  end

  def current_user?(user)
    user == current_user
  end

  def require_signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in.5464"
    end
  end

  def require_admin_user
    redirect_to(root_path) unless current_user.admin? || current_user.owner?
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
