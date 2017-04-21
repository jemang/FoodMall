class OrderitemsController < ApplicationController
  before_action :set_orderitem, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  # GET /orderitems
  # GET /orderitems.json
  def index
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end

    params[:q] ||= {}
    if params[:q][:updated_at_lteq].present?
        params[:q][:updated_at_lteq] = params[:q][:updated_at_lteq].to_date.end_of_day
    end

    @search = Orderitem.ransack(params[:q])
    @search.sorts = 'updated_at desc' if @search.sorts.empty?
    @orderitems = @search.result.paginate(:per_page => 30, :page => params[:page])
    @users = User.all
  end

  def view_orderitem
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end

    @search = User.ransack(params[:q])
    @search.sorts = 'username asc' if @search.sorts.empty?
    @users = @search.result
    @date = Date.today.strftime("%d/%m/%Y")
    @orderitems = Orderitem.all
    @orderitems.each do |d|
      if d.updated_at.strftime('%d/%m/%Y') == @date
        @rn = d.runner_id
        @ch = d.chef_id
      end
    end
  end

  def admin_order
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end

    @orderitem = Orderitem.new
    @users = User.all
  end

  def selected_user
    @display = params[:dd]
    @search = Orderitem.ransack(params[:q])
    @complete = Orderitem.where(status: "complete").ransack(params[:q])
    @search.sorts = 'updated_at desc' if @search.sorts.empty?
    @complete.sorts = 'updated_at desc' if @complete.sorts.empty?
    @orderitems = @complete.result.paginate(:per_page => 30, :page => params[:page])
    @chef_runner = @search.result.paginate(:per_page => 30, :page => params[:page])
    @pending = @search.result
    @users = User.all
  end

  def print
    @owner = params[:id]
    @date = Date.today
    @orderitems = Orderitem.where(updated_at: @date.midnight..@date.end_of_day)
    @users = User.all
    @items = Item.all
    @usr = Orderitem.select(:user_id).uniq

    if params[:date] != nil
      @owner = params[:id]
      @date = Date.parse(params[:date])
      @orderitems = Orderitem.where(updated_at: @date.midnight..@date.end_of_day)
      @users = User.all
      @items = Item.all
    end

  end

  # GET /orderitems/1
  # GET /orderitems/1.json
  def show
  end

  # GET /orderitems/new
  def new
    @item = Item.find(params[:item_id])
    @orderitem = Orderitem.new
    @setdefault = Setdefault.all
    @setdefault.each do |set|
      if set.user == current_user
        @chef = set.chef
        @runner = set.runner
      else
        @chef = nil
        @runner = nil
      end
    end
  end

  # GET /orderitems/1/edit
  def edit

  end

  # POST /orderitems
  # POST /orderitems.json
  def create
    @orderitem = Orderitem.new(orderitem_params)
    @orderitem = Orderitem.new(order_params)

    respond_to do |format|
      if current_user.role.eql?('admin')
        if @orderitem.save
          flash[:success] = 'Orderitem was successfully created.'
          format.html { redirect_to '/' }
          format.json { render :show, status: :created, location: @orderitem }
        else
          @users = User.all
          format.html { render :admin_order }
          format.json { render json: @orderitem.errors, status: :unprocessable_entity }
        end

      else

        if @orderitem.save
          flash[:success] = 'Orderitem was successfully created.'
          format.html { redirect_to '/' }
          format.json { render :show, status: :created, location: @orderitem }
        else
          @item = Item.find(@orderitem.item_id)
          format.html { render :new }
          format.json { render json: @orderitem.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /orderitems/1
  # PATCH/PUT /orderitems/1.json
  def update
    respond_to do |format|
      if @orderitem.update(orderitem_params)
        flash[:success] = 'Orderitem was successfully updated.'
        format.html { redirect_to '/' }
        format.json { render :show, status: :ok, location: @orderitem }
      else
        format.html { render :edit }
        format.json { render json: @orderitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orderitems/1
  # DELETE /orderitems/1.json
  def destroy
    @orderitem.destroy
    respond_to do |format|
      flash[:success] = 'Orderitem was successfully canceled.'
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def edit_cust_order
    @order_id = params[:orderitem_ids]
    unless @order_id.nil?
      @orderitems = Orderitem.find(@order_id)
      @users = User.all
    else
      redirect_to '/view_orderitem'
    end
  end

  def update_cust_order
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @orderitems.each do |orderitem|
      if orderitem.status.eql?('ordered') || orderitem.status.eql?('processing')
          orderitem.update_attribute(:status, 'processing')
          orderitem.update(cust_order_params)
      else
          orderitem.update(cust_order_params)
      end
    end
    flash[:success] = 'Order Updated.'
    redirect_to '/view_orderitem'
  end

  def edit_multiple
    @order_id = params[:orderitem_ids]
    if @order_id.nil? == false
      @orderitems = Orderitem.find(@order_id)
      @setdefault = Setdefault.all
      
      @sum = 0
      @orderitems.each do |orderitem|
        @sum = orderitem.total.to_i + @sum
      end
    else
      redirect_to '/'
    end
    
  end

  def update_multiple
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @orderitems.each do |orderitem|
      orderitem.update(multi_params)
    end
    flash[:success] = 'Order was successfully send.'
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orderitem
      @orderitem = Orderitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orderitem_params
      params.require(:orderitem).permit(:quantity, :note, :total, :status, :runner_id, :chef_id, :item_id, :user_id, :dtime, :current_user_id)
    end

    def order_params
      params.require(:orderitem).permit(:quantity, :note, :total, :status, :runner_id, :chef_id, :item_id, :user_id, :dtime, :current_user_id)
    end

    def multi_params
      params.require(:orderitem).permit(:status, :dtime, :totalprice, :current_user_id)
    end

    def cust_order_params
      params.require(:orderitem).permit(:runner_id, :chef_id, :current_user_id)
    end

end
