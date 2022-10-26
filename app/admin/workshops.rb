ActiveAdmin.register Workshop do
  includes :zone, :creator, :category

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :goal, :description, :more, :audience, :seats, :main_picture, :category_id, :creator_id, :statut, :zone_id, :showcased, :visible, :crop_x, :crop_y, :crop_width, :crop_height, :giftable, :hide_end_time, :online, :shipment,
    pictures: [],
    workshop_duration_attributes: %i[id hours minutes],
    address_attributes: %i[id street postal_code city _destroy],
    workshop_events_attributes: %i[id start_time _destroy],
    workshop_prices_attributes: %i[id category seats price _destroy]
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :goal, :description, :more, :audience, :category_id, :seats, :validated_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :title
  
  filter :creator, collection: -> {
    Creator.all.map { |creator| [creator.email, creator.id] }
  }
  filter :statut, as: :select, collection: Workshop.statuts
  filter :audience, as: :select, collection: Workshop.audiences
  filter :goal
  filter :description
  filter :more
  filter :seats
  filter :zone
  filter :category
  filter :showcased
  filter :visible 
  filter :giftable
  filter :hide_end_time
  filter :online
  filter :shipment

  index do
    selectable_column
    column :id
    column "Titre" do |workshop|
      link_to workshop.title, admin_workshop_path(workshop)
    end
    column :created_at
    column :updated_at
    column :category
    column :seats
    column :showcased
    column :creator
    column :visible
    column :giftable
    column :online
    column :shipment
    column :zone
    column :statut
    column "Modifier" do |workshop|
      link_to 'Modifier', edit_admin_workshop_path(workshop)
    end
    column "Supprimer" do |workshop|
      link_to 'Supprimer', "workshops/#{workshop.id}", :method => :delete
    end
  end



  show do
    default_main_content

    panel "Dates" do
      table_for workshop.workshop_events.order(start_time: :asc) do
        column "Date" do |event|
          link_to l(event.start_time, format: :event), admin_workshop_event_path(event)
        end

        column "Places restantes" do |event|
          event.seats_left
        end
      end
    end

    panel "Tarifs" do
      table_for workshop.workshop_prices do
        column "Categorie" do |price|
          price.category
        end

        column "Prix" do |price|
          short_number_to_currency price.price_cents/100
        end
      end
    end
    
    attributes_table do
      row :main_picture do |workshop|
        if workshop.main_picture.attached?
          image_tag url_for(workshop.main_picture)
        else
          "Pas de photo"
        end
      end

      table_for workshop.pictures do
        column "Photo" do |picture|
          image_tag url_for(picture)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :zone
      f.input :online
      f.input :shipment
      # f.input :showcased
      f.input :visible
      f.input :giftable
      f.input :hide_end_time
      f.input :title
      f.input :goal
      f.input :description
      f.input :more
      f.input :main_picture, as: :file
      f.input :pictures, as: :file, input_html: {multiple: true}
      f.input :category
      f.input :creator, member_label: proc { |c| "#{c.first_name} #{c.last_name} (#{c.email})" }
      f.input :seats
      f.input :audience, as: :select, collection: Workshop.audiences.keys
      f.input :statut, as: :select, collection: Workshop.statuts.keys
      f.input :crop_x
      f.input :crop_y
      f.input :crop_width
      f.input :crop_height

      f.inputs do
        f.has_many :workshop_duration, heading: "Durée", new_record: true do |duration|
          duration.input :hours
          duration.input :minutes
        end
      end

      f.inputs do
        f.has_many :address, heading: "Adresse", new_record: true, class: "has_one" do |address|
          address.input :street
          address.input :postal_code
          address.input :city
        end
      end

      f.inputs do
        f.has_many :workshop_events,
          heading: "Dates",
          allow_destroy: true,
          new_record: true do |event|
          event.input :start_time, as: :date_time_picker, datepicker_options: {step: 15}
        end
      end

      f.inputs do
        f.has_many :workshop_prices,
          heading: "Prix",
          allow_destroy: true,
          new_record: true do |price|
          price.input :category, as: :select, collection: WorkshopPrice.categories.keys
          price.input :price
          price.input :seats
        end
      end
    end
    f.actions
  end
end
