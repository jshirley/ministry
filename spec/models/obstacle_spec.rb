require 'spec_helper'
require "cancan/matchers"

describe Obstacle do
  let!(:project) { FactoryGirl.create(:project) }
  let(:owner)    { project.user }

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

  context "serialization" do
    let(:description) { "An obstacle, impeding our progress!" }
    let(:strategy)    { "How we will overcome." }
    let(:results)     { "The results we expect." }
    let(:flag)        { 0 }

    let(:obstacle) {
      project.obstacles.create!(
        user: project.user,
        description: description,
        strategy: strategy,
        results: results,
        flag: flag
      )
    }

    it "refreshes search" do
      # FIXME: This is a bad, some may say stupid, way of running this test.
      clean_es!

      # Because we then create (and touch project, which inserts it into ElasticSearch)
      obstacle

      # Wait for a refresh of the index, so the document is stored.
      Project.tire.index.refresh

      results = Project.search("name:#{project.name}")
      match   = results.first

      expect(match[:obstacles].size).to eq(project.obstacles.count)
      expect(match[:obstacles][0][:id]).to eq(obstacle.id)

      # Call this to delete all indexes. If you want this automatic, uncomment it in spec/spec_helper.rb L46
      clean_es!
    end

  end
end
