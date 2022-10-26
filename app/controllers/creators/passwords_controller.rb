# frozen_string_literal: true

class Creators::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    
  end

  # PUT /resource/password
  def update
    if current_creator.update_with_password(password_params)
      flash[:notice] = 'password update succeed..'
      render :edit
    else
      flash[:error] = 'password update failed.'
      render :edit
    end
  end

  protected

  def password_params
    params.require(:creator).permit(:current_password, :password, :password_confirmation)
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
