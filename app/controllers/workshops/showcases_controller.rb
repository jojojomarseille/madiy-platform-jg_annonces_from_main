module Workshops
  class ShowcasesController < BaseController
    layout false

    def index
      @workshops = Workshop.showcased.distinct
    end
  end
end
