class MembershipsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def new

  end

  def create
    data = membership_params

    @project = Project.find(data[:project_id])
    @role    = @project.roles.find(data[:role_id])

    # Are we applying or inviting?
    @membership = nil
    notice = nil

    # Inviting!
    if can? :manage, @project
      data = data.merge(
        project:  @project,
        accepted: false,
        approved: true,
        accepted: false
      )

      existing_user = User.where(email: data[:email]).first
      unless existing_user.nil?
        data[:user_id] = existing_user.id
      end

      @membership = @role.memberships.build(data)
      notice = t('role_invited_notice')
    else
      # Applying, requires the role can be applied to
      unless @role.can_apply?(current_user)
        redirect_to project_role_path(@project, @role), alert: t('cannot_apply_alert')
        return
      end

      data = data.merge(
        project:  @project,
        user:     current_user,
        accepted: true,
        approved: false,
        accepted: true,
        email:    current_user.email
      )

      @membership = @role.memberships.build(data)

      notice = t('role_applied_notice')
    end

    if @membership and @membership.valid?
      @membership.save!
      logger.info "Sending email now!"
      MembershipMailer.notify(@membership).deliver!

      redirect_to project_path(@project), notice: notice
    else
      logger.debug @membership.errors.full_messages
      redirect_to project_role_path(@project, @role), alert: t('membership_create_alert')
    end
  end

  def show
    if @membership.user_id == current_user.id
      render "show_owner"
    elsif can? :manage, @project
      render "show_manager"
    end
  end

  def update
    data = membership_params
    notice = nil

    @membership.note = data[:note]

    if @membership.user_id == current_user.id
      @membership.accepted = data[:accepted] ? true : false
      notice = t('role_accepted_notice')
    elsif can? :manage, @membership.project
      @membership.approved = data[:approved] ? true : false
      notice = t('role_approved_notice')
    end

    if @membership.save!
      redirect_to project_path(@project), notice: notice
    else
      redirect_to membership_path(@membership), alert: t('membership_update_alert')
    end
  end

  private
  def membership_params
    params.require(:membership).permit(:project_id, :role_id, :note, :accepted, :approved, :email)
  end
end
