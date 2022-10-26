class AddNewsletterMemberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :newsletter_member, :boolean, null: false, default: false
  end
end
