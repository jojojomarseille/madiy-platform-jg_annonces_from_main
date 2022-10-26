ActiveAdmin.register CreatorDoc do
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
    permit_params [:id, :creator_id, :statut, :document_type, :document]
  
    filter :creator, collection: -> {
      Creator.all.map { |creator| [creator.email, creator.id] }
    }
    filter :statut, as: :select, collection: CreatorDoc.statuts
    filter :document_type, as: :select, collection: CreatorDoc.document_types

    index do
      selectable_column
      id_column
      column :document_type
        column :creator_id do |m|
          creator = Creator.find(m.creator_id)
          link_to creator.email, admin_creator_path(m.creator_id)
        end
      column :statut
      actions
    end

    show do
      default_main_content
  
      attributes_table do
        row :document do |creator|
          image_tag url_for(creator.document)
          link_to "Voir le document", url_for(creator.document), target: :_blank
        end
      end
    end
  
    form do |f|
      f.semantic_errors(*f.object.errors.keys)
  
      f.inputs do
        f.input :creator, member_label: proc { |c| "#{c.first_name} #{c.last_name} (#{c.email})" }
        f.input :statut, as: :select, collection: CreatorDoc.statuts.keys
        f.input :document_type, as: :select, collection: CreatorDoc.document_types.keys
        f.input :document, as: :file
      end
  
      f.actions
    end
  end
  