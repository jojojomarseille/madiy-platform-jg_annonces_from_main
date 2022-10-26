require "rails_helper"

RSpec.describe WorkshopsServices::ProposeWorkshop do
  describe ".call" do
    it "delegates to the instance" do
      instance = described_class.new
      params = attributes_for(:workshop)

      allow(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:call).with(workshop_params: params)

      described_class.call(workshop_params: params)
    end
  end

  describe "#call" do
    subject(:service) { described_class.new }

    context "on success" do
      let(:category) { create(:workshop_category) }
      let(:creator) { create(:creator) }
      let(:zone) { create(:zone) }

      let(:workshop_params) { valid_workshop_params(category, creator, zone) }

      it "creates a workshop" do
        expect {
          service.call(workshop_params: workshop_params)
        }.to change {
          Workshop.count
        }.by(1)
      end

      it "returns a successful context" do
        context = service.call(workshop_params: workshop_params)

        expect(context.success).to be(true)
      end

      it "returns a workshop" do
        context = service.call(workshop_params: workshop_params)

        expect(context.result).to be_a(Workshop)
      end

      it "returns a non visible workshop" do
        workshop = service.call(workshop_params: workshop_params).result

        expect(workshop).not_to be_visible
      end
    end

    context "on failure" do
      let(:workshop_params) { Hash[] }

      it "does not create a workshop" do
        expect {
          service.call(workshop_params: workshop_params)
        }.not_to change { Workshop.count }
      end

      it "returns a failure context" do
        context = service.call(workshop_params: workshop_params)

        expect(context.success).to be(false)
      end

      it "returns a not persisted workshop" do
        context = service.call(workshop_params: workshop_params)

        expect(context.result).not_to be_persisted
      end
    end
  end
end
