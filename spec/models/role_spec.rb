require 'spec_helper'

describe Role do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:user) {
    FactoryGirl.create(:user,
      email: Faker::Internet.email,
    )
  }

  let!(:role) { project.roles.create(name: 'Developer', quantity: 1) }

  it "has unfilled roles" do
    expect(project.unfilled_roles.count).to eq(1)
    expect(project.unfilled_roles.first.id).to eq(role.id)
  end

  it "fills roles" do
    expect {
      project.memberships.create!(
        user: user,
        role: role,
        email: user.email,
        accepted: true,
        approved: true
      )
    }.to change {
      project.unfilled_roles.count
    }.from(1).to(0)
  end

  it "increments fill count on create" do
    expect {
      project.memberships.create!(
        user: user,
        role: role,
        email: user.email,
        accepted: true,
        approved: true
      )
    }.to change {
      role.filled_count
    }.from(0).to(1)
  end

  it "decrements fill count on destroy" do
    membership = project.memberships.create!(
      user: user,
      role: role,
      email: user.email,
      accepted: true,
      approved: true
    )
    expect {
      membership.destroy!
    }.to change {
      role.filled_count
    }.from(1).to(0)
  end

  it "decrements fill count on update" do
    documenter = project.roles.create(name: 'Documenter', quantity: 1)
    membership = project.memberships.create!(
      user: user,
      role: role,
      email: user.email,
      accepted: true,
      approved: true
    )
    expect {
      membership.update_attributes(role_id: documenter.id)
    }.to change {
      role.filled_count
    }.from(1).to(0)
    expect(documenter.filled_count).to eq(1)
  end

end
