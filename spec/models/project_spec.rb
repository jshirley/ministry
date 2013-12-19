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

      expect(ProjectSerializer.new(project).to_json).to include(%Q("name":"#{value.field.name}","value":"#{value.value}"))
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
