class NewsletterMembersController < BaseController
  def create
    member = OpenStruct.new(member_params)
    result = Mailchimp::UpsertNewsletterMember.new.call(user: member)

    if result.success
      redirect_to root_url, notice: t(".success")
    else
      render status: :unprocessable_entity, locals: {errors: result.errors}
    end
  end

  private

  def member_params
    params.require(:member).permit(:email)
  end
end
