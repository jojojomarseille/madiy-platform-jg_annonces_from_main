ActiveAdmin.register Creator do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :first_name, :last_name, :phone_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :first_name, :last_name, :phone_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params [:email, :password, :password_confirmation, :first_name, :last_name, :phone_number, :website, :facebook, :instagram, :bio, :picture, :company, :approved, :click_and_collect]

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    # column :approved
    actions
  end

  show do
    default_main_content

    attributes_table do
      row :picture do |creator|
        if creator.picture.attached?
          image_tag creator.picture
        else
        end
      end
    end

    panel "Ateliers" do
      table_for creator.workshops do
        column "Titre" do |workshop|
          link_to workshop.title, admin_workshop_path(workshop)
        end

        column "Statut" do |workshop|
          workshop.statut
        end
      end
    end

    panel "Creators Docs" do
      table_for creator.creator_docs do
        column "id" do |doc|
          link_to doc.id, admin_creator_doc_path(doc)
        end

        column "Type" do |doc|
          doc.document_type
        end

        column "statut" do |doc|
          doc.statut
        end
      end
    end


  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :click_and_collect
      f.input :email

      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end

      f.input :first_name
      f.input :last_name
      f.input :company
      f.input :phone_number
      f.input :website
      f.input :facebook
      f.input :instagram
      f.input :bio
      # f.input :approved
      f.input :picture, as: :file
    end

    f.actions
  end
end
