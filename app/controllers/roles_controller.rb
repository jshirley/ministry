class RolesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :project
  load_and_authorize_resource :role, through: :project

  def index
  end

  def names
    list = @project.roles.pluck(:name) + Role.default_role_names
    list.uniq!
    list.compact!

    respond_to do |format|
      format.json { render json: list, root: false }
    end
  end

  def new
    @role = @project.roles.build

    if flash[:role]
      @role.assign_attributes(flash[:role])
      @role.valid?
      flash.delete(:role)
    end
  end

  def create
    data = role_data
    @role = @project.roles.build(data)
    if @role.valid?
      @role.save!
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('created_role_notice') }
        format.json { render json: @role }
      end
    else
      flash[:role] = data
      respond_to do |format|
        format.html { redirect_to new_project_role_path(@project), alert: t('created_role_alert') }
        format.json { render json: @role.errors }
      end
    end
  end

  def show
    if can? :manage, @role
      render :edit and return
    end
  end

  def edit
    if flash[:role]
      @role.assign_attributes(flash[:role])
      @role.valid?
      flash.delete(:role)
    end
  end

  def update
    data = role_data

    @role.assign_attributes(data)
    if @role.valid?
      @role.save!
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('updated_role_notice') }
        format.json { render json: @role }
      end
    else
      flash[:role] = data
      respond_to do |format|
        format.html { redirect_to edit_project_role_path(@project, @role), alert: t('updated_role_alert') }
        format.json { render json: @role.errors }
      end
    end

  end

  def destroy
    @role.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: t('removed_role_notice') }
      format.json { render json: @project }
    end
  end

  private
  def role_data
    params.require(:role).permit(:name, :description, :admin, :quantity)
  end

  def load!
    @project = current_user.projects.includes(:status, :roles, memberships: :user).find(params[:project_id].to_i)
    @roles   = @project.roles

    if params[:id]
      @role = @project.roles.find(params[:id].to_i)
    end
  end
end
