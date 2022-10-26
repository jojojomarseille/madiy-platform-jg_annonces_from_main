ActiveAdmin.register User do
  preserve_default_filters!
  remove_filter :carts
  remove_filter :paid_carts
  remove_filter :cart_items

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :first_name, :last_name, :newsletter_member, :birthday, :mangopay_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :first_name, :last_name, :newsletter_member, :birthday, :mangopay_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :birthday
    actions
  end

  show do
    default_main_content

    panel "Informations de facturation" do
      attributes_table_for user.billing_detail do
        row(:first_name)
        row(:last_name)
        row(:phone_number)
        row(:company)
        row(:address)
      end
    end

  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation

      f.input :first_name
      f.input :last_name
      f.input :birthday
    end
    f.actions
  end
end
