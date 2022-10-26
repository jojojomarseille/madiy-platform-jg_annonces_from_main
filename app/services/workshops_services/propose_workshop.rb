module WorkshopsServices
  class ProposeWorkshop
    def initialize(workshop_model: Workshop)
      @workshop_model = workshop_model
      @context = OpenStruct.new(success: true, result: nil)
    end

    class << self
      def call(**parameters)
        new.call(**parameters)
      end
    end

    def call(workshop_params: {})
      create_workshop(workshop_params)
      # TODO: notify_admin

      context
    end

    private

    attr_reader :workshop_model, :context

    def create_workshop(workshop_params)
      workshop_model.new(workshop_params).tap do |workshop|
        context.success = workshop.save
        context.result = workshop
      end
    end
  end
end
