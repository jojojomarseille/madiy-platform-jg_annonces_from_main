ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Commandes récentes" do
          ul do
            Cart.paid.recent(10).map do |cart|
              li link_to("Commande #{cart.public_reference} passée le #{l(cart.paid_at, format: :short)}", admin_cart_path(cart))
            end
          end
        end
      end

      column do
        panel "Paniers avec erreur de paiement" do
          ul do
            Cart.failed.order(updated_at: :desc).map do |cart|
              if cart.user
                para link_to("Panier de l'utilisateur #{cart.user.email}", admin_user_path(cart.user))
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Demandes d'inscriptions créateurs" do
          ul do
            CreatorContact.recent(10).map do |contact|
              li link_to("Demande d'inscription de #{contact.name} (#{contact.email})", admin_creator_contact_path(contact))
            end
          end
        end
      end

      column do
        panel "Demandes d'ateliers clés en main" do
          ul do
            SpecificWorkshopContact.recent(10).map do |contact|
              para link_to("Atelier clé en main pour #{contact.name} (#{contact.email})", admin_specific_workshop_contact_path(contact))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Ateliers des 2 prochaines semaines" do
          ul do
            WorkshopEvent.in_future.until(2.weeks.from_now).map do |event|
              li link_to("Atelier #{event.workshop.title} du #{l(event.start_time, format: :event)} (#{event.seats_left} places restantes)", admin_workshop_event_path(event))
            end
          end
        end
      end

      column do
        panel "Ateliers du moment" do
          ul do
            Workshop.showcased.distinct.map do |workshop|
              li link_to("Atelier #{workshop.title}", admin_workshop_path(workshop))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Ateliers En attente de validation" do
          ul do
            Workshop.where(statut: "Soumis").each do |workshop|
              li link_to("Atelier #{workshop.title}", admin_workshop_path(workshop))
            end
          end
        end
      end
    
      column do
        panel "Dernières dates annulées" do
          ul do
            WorkshopEvent.where(canceled: true).order(updated_at: :asc).last(10).each do |event|
              li link_to("Atelier #{Workshop.find_by_id(event.workshop_id).title }du #{I18n.l(event.start_time, format: :event)}", admin_workshop_event_path(event))
            end
          end
        end
      end
    end

  end
end
