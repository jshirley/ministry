class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :load!

  def index
    @project = current_user.projects.build
  end

  def new
    @project = current_user.projects.build
    if flash[:project]
      @project.assign_attributes(flash[:project])
      @project.valid?
      flash.delete(:project)
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

  end

  def edit
    if flash[:project]
      @project.assign_attributes(flash[:project])
      @project.valid?
      flash.delete(:project)
    end
  end

  def update
    data = project_data
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
    params.require(:project).permit(:name, :tag_list)
  end

  def load!
    @projects = current_user.projects.includes(:status, :roles, memberships: :user)

    if params[:id]
      @project = @projects.find(params[:id].to_i)
    end
  end
end
