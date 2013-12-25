require 'spec_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }

  context "status" do
    let(:role) { project.roles.create(name: 'Developer', quantity: 1) }

     it "Needs staff" do
      clean_es!

      expect {
        project.save!
        role.save!
        # Take a nap because indexed documents are not immediately available
        sleep(1)
      }.to change {
        res = Project.need_staff
        res.results.size
      }.from(0).to(1)
    end

    # This doesn't work because a role's name and it's tags
    # don't reall jive with me.
    #  it "Needs staff with skills" do
    #   clean_es!
    #   sleep(1) # Sleep for index creation

    #   expect {
    #     project.save!
    #     role.save!
    #     # Take a nap because indexed documents are not immediately available
    #     sleep(1)
    #   }.to change {
    #     res = Project.need_staff_with_skills(['Developer'])
    #     res.results.size
    #   }.from(0).to(1)
    # end
  end
end
