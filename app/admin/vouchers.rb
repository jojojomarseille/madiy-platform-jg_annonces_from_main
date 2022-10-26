ActiveAdmin.register Voucher do
  preserve_default_filters!
  remove_filter :carts
 
  filter :user, collection: -> {
    User.all.map { |user| [user.email, user.id] }
  }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :amount, :from, :to, :message, :campaign, :percentage, :valid_until,
                :workshop_id, :user_id, :max_uses_by_user, :monoproduct, :notgiftcards, :minimum_amount, :max_uses,
                coupon_attributes: [:id, :token, :active]
  #
  # or
  #
  # permit_params do
  #   permitted = [:amount_cents, :from, :to, :message, :workshop_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :coupon_token
    column :from
    column :to
    column("Montant") { |voucher| Money.new(voucher.amount_cents) }
    column :percentage
    column :created_at
    column :updated_at
    column :workshop
    column :monoproduct
    column :notgiftcards
    actions
  end

  controller do
    def scoped_collection
      end_of_association_chain.joins(:coupon).merge(Coupon.active)
    end

    def find_resource
      Voucher.find(params[:id])
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :campaign, as: :boolean, input_html: { checked: f.object.persisted? ? f.object.campaign : true }
      f.input :valid_until, as: :date_time_picker
      f.input :minimum_amount
      f.input :max_uses_by_user
      f.input :max_uses
      # f.input :user
      f.input :user, member_label: proc { |c| "#{c.first_name} #{c.last_name} (#{c.email})" }
      f.input :from
      f.input :to
      f.input :workshop, as: :select, collection: Workshop.where(statut: ["Validé", "Soumis"])
      f.input :amount
      f.input :percentage
      f.input :monoproduct
      f.input :notgiftcards

      f.inputs do
        f.has_many :coupon, heading: "Code", new_record: true, class: "has_one" do |coupon|
          coupon.input :token
          coupon.input :active
        end
      end
    end
    f.actions
  end

  show do
    default_main_content

    h2 "Commandes bénéficiant de la carte cadeau"
    table_for voucher.carts.paid do
      column("Commande") { |cart| link_to(cart.id, polymorphic_url([:admin, cart])) }
      column("Référence interne") { |cart| cart.reference }
      column("Numéro Mangopay") { |cart| link_to(cart.transaction_id, "https://dashboard.mangopay.com/PayIn/#{cart.transaction_id}", target: "blank") }
    end
  end
end
