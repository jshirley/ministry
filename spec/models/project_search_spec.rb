require 'spec_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }

  context "status" do
    let(:role) { project.roles.create(name: 'Developer', quantity: 1) }

     it "from ElasticSearch" do
      clean_es!
      project.save!
      role.save!

      expect {
        project.tag_list = %w(play scala java jquery)
        project.save!
        # Take a nap because indexed documents are not immediately available
        sleep(1)
      }.to change {
        res = Project.need_staff
        res.results.size
      }.from(0).to(1)
    end
  end
end
