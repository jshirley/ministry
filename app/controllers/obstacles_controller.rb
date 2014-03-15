class ObstaclesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :project
  load_and_authorize_resource :obstacle, through: :project

  def index

  end

  def new
    logger.ap flash[:obstacle]
    @obstacle.user = current_user

    if flash.key?(:obstacle)
      @obstacle.assign_attributes(flash[:obstacle])
      @obstacle.valid?
      logger.ap @obstacle.errors
      flash.delete(:obstacle)
    end
  end

  def create
    logger.ap @obstacle
    @obstacle.user = current_user
    if @obstacle.valid?
      @obstacle.save!
      respond_to do |format|
        format.html { redirect_to project_obstacles_path(@project), notice: t('created_obstacle_notice') }
        format.json { render json: @obstacle }
      end
    else
      flash[:obstacle] = obstacle_params
      respond_to do |format|
        format.html { redirect_to new_project_obstacle_path(@project), alert: t('created_obstacle_alert') }
        format.json { render json: { errors: @obstacle.errors } }
      end
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
  def obstacle_params
    params.require(:obstacle).permit(:description, :strategy, :results, :row_order, :flag)
  end
end
