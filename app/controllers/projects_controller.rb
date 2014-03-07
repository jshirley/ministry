class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @project = current_user.projects.build
  end

  def search

  end

  def new
    @project = current_user.projects.build

    if flash[:project]
      @project.assign_attributes(flash[:project])
      @project.valid?
      flash.delete(:project)
    else
      # Nothing in Flash, we have to populate these manually.
      Field.default_fields.each do |field|
        @project.field_values.build(field: field, user: current_user)
      end
    end
  end

  def create
    data = project_data
    if data[:status_id].blank?
      # Need to populate with default status
      data[:status_id] = Status.initial_status.id
    end

    @project = current_user.projects.build(data)
    if @project.valid?
      @project.save!
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('created_project_notice') }
        format.json { render json: @project }
      end
    else
      flash[:project] = data
      respond_to do |format|
        format.html { redirect_to new_project_path, alert: t('created_project_alert') }
        format.json { render json: @project.errors }
      end
    end
  end

  def show
    @roles = @project.roles
  end

  def edit
    if flash[:project]
      @project.assign_attributes(flash[:project])
      @project.valid?
      flash.delete(:project)
    end

    @roles = @project.roles
  end

  def advance
    event = params[:event]

    state_was = @project.aasm.current_state.capitalize

    may_name = "may_#{event}?".to_sym

    if @project.respond_to?(may_name) and @project.send(may_name)
      @project.send(event.to_sym)
      @project.save!
      state = @project.aasm.current_state.capitalize
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('advanced_project_notice', state_was: state_was, state: state.to_s.capitalize) }
        format.json { render json: @project }
      end
    else
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('advanced_project_alert', state_was: state_was, event: event.to_s.capitalize) }
        format.json { render json: { error: t('advanced_project_alert', state_was: state_was, event: event.to_s ) } }
      end

    end
  end

  def update
    data = project_data
    logger.ap data

    @project.assign_attributes(data)
    if @project.valid?
      @project.save!
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('updated_project_notice') }
        format.json { render json: @project }
      end
    else
      flash[:project] = data
      respond_to do |format|
        format.html { redirect_to edit_project_path(@project), alert: t('updated_project_alert') }
        format.json { render json: @project.errors }
      end
    end

  end

  def destroy

  end

  private
  def project_data
    params.require(:project).permit(:name, :tag_list, field_values_attributes: [ :id, :field_id, :value ])
  end

  def load!
    @projects = current_user.projects.includes(:status, :roles, memberships: :user)

    id = params[:project_id] || params[:id]
    unless id.blank?
      @project = @projects.find(id.to_i)
    end
  end
end
