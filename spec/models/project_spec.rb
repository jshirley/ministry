require 'spec_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }

  context "fields" do
    it "creates default fields" do
      expect(project.field_values.size).to eq(Field.default_fields.size)
      expect(project.field_values.first.field.name).to eq(Field.default_fields[0].name)
    end

    it "sets field values and serializes" do
      user    = project.user
      value   = project.field_values.includes(:field).first

      value.update_attributes(user: user, value: "Foo")

      # TODO: Why do we need to reload? touch: true is on FieldValue
      project.reload

      expect(ProjectSerializer.new(project).to_json).to include(%Q("name":"#{value.field.name}","value":"#{value.value}"))
    end

    # This is mostly for my own understanding of ActiveRecord
    it "deletes field values but leaves fields" do
      user     = project.user
      value    = project.field_values.includes(:field).first
      value_id = value.id
      field_id = value.field_id

      project.destroy

      expect(FieldValue.where(id: value_id).count).to eq(0)
      expect(Field.where(id: field_id).count).to eq(1)
    end
  end

  context "status" do
    let(:role) { project.roles.create(name: 'Developer', quantity: 1) }

    it "progresses through states" do
      expect(project.pending?).to be_true

      expect(project.may_staff?).to be_true

      expect {
        project.staff
      }.to change {
        project.may_schedule?
      }.from(false).to(true)

      expect {
        project.schedule
      }.to change {
        project.may_work?
      }.from(false).to(true)

      # When we do work, we can go to fail or succeed
      expect {
        project.work
      }.to change {
        project.may_succeed?
      }.from(false).to(true)

      expect(project.may_fail?).to be_true

      # Once we have a success (or fail) state we cannot abandon. It's done!
      expect {
        project.succeed
      }.to change {
        project.may_abandon?
      }.from(true).to(false)
    end

    it "guards against scheduling unstaffed projects" do
      expect(role.id).to be_true

      project.staff

      expect(project.may_schedule?).to be_false

      expect {
        project.memberships.create!(
          user: project.user,
          role: role,
          email: project.user.email,
          accepted: true,
          approved: true
        )
      }.to change {
        project.may_schedule?
      }.from(false).to(true)
    end
  end

  context "tagging and discovery" do
    it "allows tagging on project" do
      expect {
        project.tag_list = %w(scala play)
        project.save!
      }.to change {
        Project.tagged_with('scala').count
      }.from(0).to(1)
    end
  end

  context "search" do
    let!(:project) {
      FactoryGirl.create(:project)
    }
    let(:user) {
      FactoryGirl.create(
        :user,
        email: Faker::Internet.email,
        skill_list: %w(scala perl)
      )
    }

    it "refreshes search" do
      Project.tire.index.refresh

      results = Project.search("name:#{project.name}")
      expect(results.first.name).to eq(project.name)

      # Call this to delete all indexes. If you want this automatic, uncomment it in spec/spec_helper.rb L46
      clean_es!
    end

    context "matching search" do
      it "from DB query" do
        expect {
          project.tag_list = %w(scala play)
          project.save!
        }.to change {
          Project.tagged_with(user.skills, any: true).count
        }.from(0).to(1)

        clean_es!
      end

      it "from ElasticSearch" do
        clean_es!

        u = user
        expect {
          project.tag_list = %w(play scala java jquery)
          project.save!
          # Take a name because indexed documents are not immediately available
          sleep(1)
        }.to change {
          res = Project.matched_to_user(user)
          res.results.size
        }.from(0).to(1)

      end
    end
  end

end
