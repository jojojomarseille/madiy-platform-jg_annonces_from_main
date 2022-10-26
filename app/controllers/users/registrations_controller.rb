module Users
  class RegistrationsController < Devise::RegistrationsController
    invisible_captcha only: %i[create], honeypot: :nique_nayme, scope: :user

    def create
      super do |user|
        if user.persisted?
          Mailchimp::UpsertNewsletterMemberJob.perform_later(user: user) if user.newsletter_member?
          Mangopay::RegisterUserJob.perform_later(user: user)
          Mailers::UserSignupJob.perform_later(user: user)
        end
      end
    end

    protected

    def after_update_path_for(_)
      edit_user_registration_path
    end
  end
end
