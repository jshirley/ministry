require 'spec_helper'

describe Milestone do
  let(:project) { FactoryGirl.create(:project) }

  context "scopes" do
    it "orders milestones" do
      first = project.milestones.create!(
        user: project.user,
        date: Time.now.utc + 1.days,
        name: "First milestone"
      )
      second = project.milestones.create!(
        user: project.user,
        date: Time.now.utc + 2.days,
        name: "Second milestone"
      )
      expect(project.milestones.pluck(:name)).to eq([ first.name, second.name ])
    end 

    it "past and future scopes" do
      first = project.milestones.create!(
        user: project.user,
        date: Time.now.utc - 1.days,
        name: "First milestone"
      )
      second = project.milestones.create!(
        user: project.user,
        date: Time.now.utc + 1.days,
        name: "Second milestone"
      )
      expect(project.milestones.past.pluck(:name)).to eq([ first.name ])
      expect(project.milestones.future.pluck(:name)).to eq([ second.name ])
    end 
  end
end
