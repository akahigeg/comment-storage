require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe ".create" do
    before(:all) do
      Setting.delete_all
    end

    after(:all) do
      Setting.delete_all
    end

    it "Confirm setting count is 0 before create" do
      expect(Setting.count).to eq 0
    end

    context "When setting not exist" do
      it "A new setting is created" do
        expect { Setting.create(default_approved: true, client_key: 'dummy1') }.to change{ Setting.count }.to(1).from(0)
      end
    end

    context "When already setting exists" do
      before do
        Setting.create(default_approved: true, client_key: 'dummy1')
      end

      it "A new setting is not created" do
        expect { Setting.create(default_approved: true, client_key: 'dummy2') }.not_to change{ Setting.count }
      end

      it "Not overrided" do
        expect(Setting.first.client_key).to eq 'dummy1'

      end
    end

  end
end
