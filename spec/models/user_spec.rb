require 'spec_helper'

describe User do
  context "relationships" do
    let(:user) { FactoryGirl.create(:user) }
    let(:status) { FactoryGirl.create(:status, name: "Pending") }

    it "has projects" do
      expect {
        user.projects.create!(
          name: "Hello World",
          status: status
        )
      }.to change {
        user.projects.count
      }.from(0).to(1)

    end
  end

  context "search" do
    let!(:project) { FactoryGirl.create(:project) }

    it "refreshes search" do
      Project.tire.index.refresh

      results = Project.search("name:#{project.name}")
      expect(results.first.name).to eq(project.name)
    end
  end
end
