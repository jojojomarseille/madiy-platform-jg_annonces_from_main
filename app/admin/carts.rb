ActiveAdmin.register Cart do
  preserve_default_filters!
  filter :user, collection: -> {
    User.all.map { |user| [user.email, user.id] }
  }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :paid_at, :user_id, :state, :transaction_id, :reference
  #
  # or
  #
  # permit_params do
  #   permitted = [:paid_at, :user_id, :state, :transaction_id, :reference]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show

  controller do
    def scoped_collection
      end_of_association_chain.where(state: "paid")
    end
  end

  show do
   default_main_content

    h2 "Produits"
    table_for cart.cart_items do
      column(:cartable) { |item| link_to(item.cartable.to_s, polymorphic_url([:admin, item.cartable])) }
      column :quantity
      column(:price_cents) { |item| Money.new(item.amount_cents) }
    end

    if cart.discount.present?
      h2 "Code promo"
      table_for cart.discount do
        column("Carte cadeau") { |discount| link_to(discount.voucher.to_s, polymorphic_url([:admin, discount.voucher])) }
        column("Montant utilisé") { |discount| Money.new(discount.amount_cents) }
        column("Commande de la carte cadeau") do |discount|
          cart_item = CartItem.find_by(cartable: discount.voucher)

          if cart_item
            link_to(cart_item.cart.id, polymorphic_url([:admin, cart_item.cart]))
          else
            "Carte cadeau non liée à une commande"
          end
        end
      end
    end
  end
end
