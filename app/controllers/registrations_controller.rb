# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    if super
      user = User.where( email: params[:user][:email] ).first
      log_action('registered', user) if user
    end
  end

  def update
    if super
      user = User.where( email: params[:user][:email] ).first
      log_action('updated', user) if user
    end
  end
end 
