class MembershipMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify(membership)
    @membership = membership
    @project    = membership.project
    @role       = membership.role
    @managers   = @project.managers
    @user       = membership.user_id.nil?? nil : membership.user

    @registration_url = new_user_registration_path(only_path: false)
    @sign_in_url      = new_user_session_path(only_path: false)

    if membership.accepted == true and membership.approved = false
      notify_admins(membership)
    elsif membership.accepted == false and membership.approved = true
      if membership.user_id.nil?
        invite_unknown(membership)
      else
        invite_known(membership)
      end
    end
  end

  private
  def notify_admins(membership)
    logger.info "Sending email to admins: #{@managers.pluck(:email)} for #{@user}"
    # FIXME: Need to set locale better, if it's for the managers it should be localized to each.
    mail(
      to: @managers.pluck(:email),
      subject: I18n.t('notify_application_subject', project: @project.name, role: @role.name, user: @user.display_name),
      template_name: 'notify_admins'
    )
  end

  def invite_unknown(membership)
    logger.info "Sending email for an unknown invitation to #{membership}"
    mail(
      to: membership.email,
      subject: I18n.t('notify_invited_subject', project: @project.name, role: @role.name),
      template_name: 'invite_unknown'
    )
  end

  def invite_known(membership)
    logger.info "Sending email for an *known user* invitation to #{@user.email}"
    mail(
      to: @user.email,
      subject: I18n.t('notify_invited_subject', project: @project.name, role: @role.name),
      template_name: 'invite_known'
    )
  end
end
