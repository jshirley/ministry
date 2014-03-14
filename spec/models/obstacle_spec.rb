require 'spec_helper'
require "cancan/matchers"

describe Obstacle do
  let!(:project) { FactoryGirl.create(:project) }
  let(:owner)    { project.user }

  pending "add some examples to (or delete) #{__FILE__}"

  context "validation" do
    it "requires user" do
      obstacle = project.obstacles.build(flag: 0)
      expect(obstacle.valid?).to be_false
      expect(obstacle.errors[:user]).to eq(["can't be blank"])
    end

    it "requires project" do
      obstacle = Obstacle.new(user: owner, flag: 0)
      expect(obstacle.valid?).to be_false
      expect(obstacle.errors[:project].size).to eq(1)
    end
  end

  context "authorization" do
    subject(:ability) { Ability.new(user) }
    context "collaborators" do
      let(:user) { owner }
      it "allows collaborators to create obstacles"
      it "allows collaborators to update obstacles"
    end

    context "non-collaborators" do
      let(:user) { FactoryGirl.create(:user) }
      it "does not allow non-collaborators to create obstacles" do
        obstacle = project.obstacles.create(
          user: owner,
          flag: 0
        )
        should_not be_able_to(:manage, obstacle)
      end

      it "does not allow non-collaborators to update obstacles"
    end
  end
end
