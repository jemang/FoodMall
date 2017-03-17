class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  # GET /items
  # GET /items.json
  def index
    @search = Item.ransack(params[:q])
    @search.sorts = 'name asc' if @search.sorts.empty?
    @items = @search.result.paginate(:per_page => 20, :page => params[:page])
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        flash[:success] = 'Item was successfully created.'
        format.html { redirect_to @item }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        flash[:success] = 'Item was successfully updated.'
        format.html { redirect_to @item }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      flash[:success] = 'Item was successfully destroyed.'
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  def my_task
    @items = Item.all
    @search = Orderitem.ransack(params[:q])
    @search.sorts = 'dtime asc' if @search.sorts.empty?
    @orderitems = @search.result
  end

  def cust_order
    @search = Orderitem.ransack(params[:q])
    @search.sorts = 'item_name asc' if @search.sorts.empty?
    @orderitems = @search.result
    
  end

  def update_stask
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @orderitems.each do |orderitem|
      if orderitem.status.eql?('processing')
          orderitem.update_attribute(:status, 'delivering')
      elsif orderitem.status.eql?('delivering')
          orderitem.update_attribute(:status, 'complete')
      end 
    end
    flash[:success] = 'Success!!'
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :price, :note, :photo)
    end
end
