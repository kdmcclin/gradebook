class AssignmentsController < ApplicationController
  def index
    @assignments = Assignment.all
  end

  def show
    @assignment = Assignment.find params[:id]
  end

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new create_params
    @assignment.sync_from_gist! octoclient
    if @assignment.save
      redirect_to @assignment, success: 'Assignment created'
    else
      render :show
    end
  end

  def edit
    @assignment = Assignment.find params[:id]
  end

  def update
    @assignment = Assignment.find params[:id]
    if @assignment.update update_params
      @assignment.sync_issues!
      redirect @assignment, success: 'Assignment updated'
    else
      render :edit
    end
  end

  def assign
    assignment = Assignment.find params[:id]
    team = if params[:team_id]
      Team.find params[:team_id]
    else
      current_user.active_team
    end
    team.assign! octoclient, assignment
    redirect_to :back, success: 'Assigned issues'
  end

  def check
    assignment = Assignment.find params[:id]
    assignment.check! octoclient
    redirect_to :back
  end

  private

  def create_params
    params.require(:assignment).permit :gist_id, :due_at
  end
end
