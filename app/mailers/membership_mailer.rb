class MembershipMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify(membership)
    if membership.accepted == true and membership.approved = false
      self.notify_admins(membership)
    elsif membership.accepted == false and membership.approved = true
      if membership.user_id.nil?
        self.invite_unknown(membership)
      else
        self.invite_known(membership)
      end
    end
  end

  private
  def notify_admins(membership)
    @project = membership.project
    @role    = membership.role

    # List of people to email
    managers = @project.managers

  end
end
