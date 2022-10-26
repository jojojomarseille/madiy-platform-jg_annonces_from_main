module Mailchimp
  class UpsertNewsletterMemberJob < ApplicationJob
    queue_as :default

    def perform(user:)
      Mailchimp::UpsertNewsletterMember.new.call!(
        user: user,
        subscribe: user.newsletter_member?
      )
    end
  end
end
