require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe ".create" do
    before(:all) do
      Setting.delete_all
    end

    after(:all) do
      Setting.delete_all
    end

    it "0" do
      expect(Setting.count).to eq 0
    end

    it "1" do
      Setting.create(default_approved: true, client_key: 'dummy1')
      expect(Setting.count).to eq 1
    end

    it "not 2" do
      Setting.create(default_approved: true, client_key: 'dummy2')
      expect(Setting.count).to eq 1
    end
  end
end
