module Workshops
    class RelatedsController < BaseController
      layout false
  
      def index
        @workshops = Workshop.related_to(workshop).order(Arel.sql('RANDOM()')).uniq

        render "workshops/showcases/index"
      end

      private

      def workshop
        Workshop.find(params[:workshop_id])
      end
    end
  end
  