require 'spec_helper'

describe Project do
  context "fields" do
    let!(:project) { FactoryGirl.create(:project) }

    it "creates default fields" do
      expect(project.field_values.size).to eq(Field.default_fields.size)
    end
  end
end
