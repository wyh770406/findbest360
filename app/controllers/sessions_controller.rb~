# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    cookies[:sign_in] = "login"
   # cookies[:sign_out] = ""
    super
  end

  # GET /resource/sign_out
  def destroy
    cookies[:sign_in] = nil
   # cookies[:sign_out] = "logout"
    super
  end
end

