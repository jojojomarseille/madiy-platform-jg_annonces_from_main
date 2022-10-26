class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts = {})
    if record.class.name == "User"
      Mailers::ResetPasswordInstructionsJob.perform_later(user: record, url: edit_password_url(:user, reset_password_token: token))
    elsif record.class.name == "Creator"
      Mailers::ResetPasswordInstructionsJob.perform_later(user: record, url: edit_creator_password_url(:user, reset_password_token: token))
    end
  end
end
