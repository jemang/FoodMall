class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @match = params[:dd]
    @setdefault = Setdefault.all
    @users = User.all
    @setdefault.each do |f|
      if f.user_id == @user.id
        @find = f.user_id
        @setid = f.id
        @setrun = f.runner
        @setchef = f.chef
      end
    end
  end

  def all_user
    @search = User.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @users = @search.result.paginate(:per_page => 30, :page => params[:page])
  end 

  def admin
    @search = User.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @users = @search.result.paginate(:per_page => 30, :page => params[:page])
    @items = Item.count
    @orderitems = Orderitem.where(status: "complete").count
    @cust = User.where(role: "customer").count
  
  end

  def customer
    @search = Item.ransack(params[:q])
    @search.sorts = 'name asc' if @search.sorts.empty?
    @items = @search.result(distinct: true)
    @orderitems = Orderitem.all
    @orderitems.each do |orderitem|
      if current_user == orderitem.user && orderitem.status == 'pre-order'
        @stat = "true"
      end
    end
  end

  def runner
    @items = Item.all
    @orderitems = Orderitem.all
    @group = @orderitems.group_by { |t| t.totalprice }
  end

  def chef
    @items = Item.all
    @orderitems = Orderitem.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @match = params[:yy]
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:fullname, :username, :email, :role, :address, :password, :password_confirmation, :phone)
    end
end
