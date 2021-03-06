# frozen_string_literal: true

# Module to check the permission level on pages
module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def permission
    session_user_id = session[:user_id]
    if deg_by_user(session_user_id)
      @permission ||= { level: 0, type: 'Deg' }
    elsif coordinator_by_user(session_user_id)
      @permission ||= { level: 1, type: 'Coordinator' }
    elsif administrativeassistant_by_user(session_user_id)
      @permission ||= { level: 2, type: 'Administrative Assistant' }
    end
  end

  def logged_in?
    return unless current_user.nil?
    flash.now[:notice] = 'Você precisa estar logado'
    render 'sessions/login'
  end

  def authenticate_coordinator?
    return unless permission[:level] != 1
    flash[:error] = 'Acesso Negado'
    redirect_to current_user
  end

  def authenticate_administrative_assistant?
    return unless permission[:level] != 2
    flash[:error] = 'Acesso Negado'
    redirect_to current_user
  end

  def authenticate_not_deg?
    return unless permission[:level].zero?
    flash[:error] = 'Acesso Negado'
    redirect_to current_user
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
    @permission = nil
  end
end
