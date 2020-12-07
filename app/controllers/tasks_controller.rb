class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :list_tasks, only: :index

  def index
  end

  def new
    @task = Task.new
  end

  def show
    @task = Task.find_by id: params[:id]
    return if @task

    redirect_to root_path
  end

  def edit
    @task = Task.find_by id: params[:id]
  end

  def update
    @task = Task.find_by id: params[:id]
    if @task.update task_params
      flash[:success] = "Edit success"
      redirect_to task_path @task
    else
      flash.now[:danger] = "edit fail"
      render :edit
    end
  end

  def create
    @task = Task.new task_params
    if @task.save
      flash[:success] = "Created ! "
    else
      flash[:success] = "Create  Fail! >.<"
      render :new
    end
    redirect_to root_path
  end

  def destroy
    @task = Task.find_by id: params[:id]
    if @task.destroy
      flash[:success] = "delete success"
    else
      flash[:error] = "delete failed"
    end

    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).merge(user_id: current_user.id).permit Task::TASKS_PARAMS
  end

  def list_tasks
    @q = current_user.tasks.ransack params[:q]
    @tasks = @q.result
    @day = Time.now
    if params[:start_time]!= nil && params[:start_time] != ""
      @tasks = @tasks.all_task_one_day params[:start_time]
      @day = params[:start_time].to_date()
    end

  end

end
