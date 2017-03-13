class OrderitemsController < ApplicationController
  before_action :set_orderitem, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  # GET /orderitems
  # GET /orderitems.json
  def index
    @display = params[:dd]
    @search = Orderitem.ransack(params[:q])
    @search.sorts = 'dtime desc' if @search.sorts.empty?
    @orderitems = @search.result
    @users = User.all

    @users.each do |orderitem|
      @sum = orderitem.id
    end

    @aa = Orderitem.where(:user_id => '4').count
  end

  def view_orderitem
    @search = User.ransack(params[:q])
    @search.sorts = 'username asc' if @search.sorts.empty?
    @users = @search.result
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

    respond_to do |format|
      if @orderitem.save
        format.html { redirect_to '/', notice: 'Orderitem was successfully created.' }
        format.json { render :show, status: :created, location: @orderitem }
      else
        format.html { render :new }
        format.json { render json: @orderitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orderitems/1
  # PATCH/PUT /orderitems/1.json
  def update
    respond_to do |format|
      if @orderitem.update(orderitem_params)
        format.html { redirect_to '/', notice: 'Orderitem was successfully updated.' }
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
      format.html { redirect_to :back, notice: 'Orderitem was successfully canceled.' }
      format.json { head :no_content }
    end
  end

  def edit_cust_order
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @users = User.all
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
    flash[:notice] = "Order Updated!!"
    redirect_to '/view_orderitem'
  end

  def edit_multiple
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @setdefault = Setdefault.all
    
    @sum = 0
    @orderitems.each do |orderitem|
      @sum = orderitem.total.to_i + @sum
    end
    
  end

  def update_multiple
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @orderitems.each do |orderitem|
      orderitem.update(multi_params)
    end
    flash[:notice] = "Order Send!!"
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orderitem
      @orderitem = Orderitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orderitem_params
      params.require(:orderitem).permit(:quantity, :note, :total, :status, :runner_id, :chef_id, :item_id, :user_id)
    end

    def multi_params
      params.require(:orderitem).permit(:status, :dtime, :totalprice)
    end

    def cust_order_params
      params.require(:orderitem).permit(:runner_id, :chef_id)
    end

end
