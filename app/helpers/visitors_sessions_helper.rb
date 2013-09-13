module VisitorsSessionsHelper

  def remember(visitor)
    remember_token = Visitor.new_remember_token
    cookies.permanent[:visitor_remember_token] = remember_token
    visitor.update_attribute(:remember_token, Visitor.encrypt(remember_token))
    self.current_visitor = visitor
  end

  def remembered?
    !current_visitor.nil?
  end

  def current_visitor=(visitor)
    @current_visitor = visitor
  end

  def current_visitor
    remember_token  = Visitor.encrypt(cookies[:visitor_remember_token])
    @current_visitor ||= Visior.find_by(remember_token: remember_token)
  end

  def current_visitor?(visitor)
    visitor == current_visitor
  end

  def remembered_visitor
    unless remembered?
      redirect_to "/" #TODO Add proper redirect to create a visitor_
    end
  end

end
