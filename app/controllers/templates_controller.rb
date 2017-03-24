class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  # GET /templates 
  # GET /templates.json
  def index
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    @users = User.all
  end

  def cron_job
    @days = params[:day]
    HardWorker.perform_async(@days)
    flash[:success] = 'Successfully added to cron job.'
    redirect_to '/template'
  end

  

  def template
    unless current_user.role.eql?('admin')
      flash[:danger] = 'You don not have access to that Page!'
      redirect_to '/'
      return
    end
    @search = Template.select(:user_id).uniq.ransack(params[:q])
    @search.sorts = 'user_username asc' if @search.sorts.empty?
    @cust = @search.result.paginate(:per_page => 10, :page => params[:page])
    @templates = Template.all
  end

  # GET /templates/new
  def new
    @template = Template.new
    @users = User.all
  end

  # GET /templates/1/edit
  def edit
    @users = User.all
  end

  # POST /templates
  # POST /templates.json
  def create
    @users = User.all
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        flash[:success] = 'Template was successfully created.'
        format.html { redirect_to '/template' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    @users = User.all
    respond_to do |format|
      if @template.update(template_params)
        flash[:success] = 'Template was successfully updated.'
        format.html { redirect_to '/template' }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      flash[:danger] = 'Template was successfully deleted.'
      format.html { redirect_to '/template' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:quantity, :day, :dtime, :total, :note, :status, :runner_id, :chef_id, :user_id, :item_id)
    end
end
