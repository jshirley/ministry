require 'spec_helper'

describe Obstacle do
  let!(:project) { FactoryGirl.create(:project) }
  let(:owner)    { project.user }

  pending "add some examples to (or delete) #{__FILE__}"

  context "validation" do
    it "requires user" do
      obstacle = project.obstacles.build(flag: 0)
      obstacle.valid?
      expect(obstacle.errors[:user].length).to eq(1)
    end

    it "requires project" do
      obstacle = Obstacle.build(user: owner, flag: 0)
      obstacle.valid?
      expect(obstacle.errors[:user].length).to eq(1)
    end
  end

  context "authorization" do
    it "allows collaborators to create obstacles"
    it "allows collaborators to update obstacles"
    it "does not allow non-collaborators to create obstacles"
    it "does not allow non-collaborators to update obstacles"
  end
end
