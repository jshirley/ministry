class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  #skip_authorize_resource only: [ :advance, :tactical, :strategic ]

  def index
    @project = current_user.projects.build
  end

  def search
    query   = params[:q]
    query   = '*' if query.blank?

    filters = params[:filter] ? filter_params : nil
    if query or filters
      @query   = query

      # If we have filters, create a lookup so
      # we can mark them as active in the view
      if filters
        @filters = {}
        filters.each do |facet, values|
          @filters[facet] = {}
          values.each do |term|
            @filters[facet][term] = true
          end
        end
      end

      @results = Project.search do
        query { string query }

        # Setup the faceting from the facetable fields (defaults)
        Project.facets.each do |facet|
          facet facet.to_s do
            terms facet
          end
        end

        # Filter if we have filters
        filter :terms, filters unless filters.nil?
      end
    end
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
    data = project_params
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
    @roles      = @project.roles
    @obstacles  = @project.obstacles
    @membership = current_user.memberships.includes(:role).where(project: @project)

    @view ||= 'strategic'

    render 'show'
  end

  def strategic
    @view = 'strategic'
    show
  end

  def tactical
    @view = 'tactical'
    show
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
    event = params[:event] || @project.aasm.current_state

    state_was = @project.aasm.current_state.capitalize

    if @project.advance_to(event)
      state = @project.aasm.current_state.capitalize
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t('advanced_project_notice', state_was: state_was, state: state.to_s.capitalize) }
        format.json { render json: @project }
      end
    else
      respond_to do |format|
        format.html { redirect_to project_path(@project), alert: t('advanced_project_alert', state_was: state_was, event: event.to_s.capitalize) }
        format.json { render json: { error: t('advanced_project_alert', state_was: state_was, event: event.to_s ) } }
      end
    end
  end

  def update
    data = project_params
    #logger.ap data

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
  def project_params
    params.require(:project).permit(:name, :tag_list, field_values_attributes: [ :id, :field_id, :value ])
  end

  def filter_params
    # Fetch the list of acceptable facetable terms from the Project model.
    list = Project.facets.map { |term| { term => [] } }
    params.require(:filter).permit(*list)
  end

  def load!
    @projects = current_user.projects.includes(:status, :roles, memberships: :user)

    id = params[:project_id] || params[:id]
    unless id.blank?
      @project = @projects.find(id.to_i)
    end
  end
end
