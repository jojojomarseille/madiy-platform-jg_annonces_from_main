module Mailchimp
  class UpsertNewsletterMember
    delegate :mailchimp, to: :'Rails.application.credentials'

    SUBSCRIBED = -"subscribed"
    UNSUBSCRIBED = -"unsubscribed"

    def initialize
      @gibbon = Gibbon::Request.new(symbolize_keys: true)
      @context = OpenStruct.new(success: true, result: nil, errors: [])
    end

    def call!(user:, subscribe: true)
      status = subscribe ? SUBSCRIBED : UNSUBSCRIBED
      list(user).upsert(body: request_body(user, status))

      @context
    end

    def call(user:, subscribe: true)
      call!(user: user, subscribe: subscribe)
    rescue Gibbon::MailChimpError => e
      @context.success = false
      @context.errors << e.detail

      @context
    end

    private

    def request_body(user, status)
      body = {
        email_address: user.email,
        status: status,
        tags: tags
      }

      if user.first_name
        body[:merge_fields] = {
          FNAME: user.first_name,
          LNAME: user.last_name
        }
      end

      body
    end

    def newsletter_list_id
      mailchimp[:newsletter_list_id]
    end

    def list(user)
      hash = Digest::MD5.hexdigest(user.email)

      @gibbon.lists(newsletter_list_id).members(hash)
    end

    def tags
      return [] if Rails.env.production?

      ["test"]
    end
  end
end
