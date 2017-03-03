class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authorize

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
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
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
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
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
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
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_task
    @items = Item.all
    @orderitems = Orderitem.all
  end

  def update_stask
    @orderitems = Orderitem.find(params[:orderitem_ids])
    @orderitems.each do |orderitem|
      if orderitem.status.eql?('ordered')
          orderitem.update_attribute(:status, 'processing')
          orderitem.update_attribute(:chef_id, current_user.id)
      elsif orderitem.status.eql?('processing')
          orderitem.update_attribute(:status, 'ready')
      elsif orderitem.status.eql?('ready')
          orderitem.update_attribute(:status, 'delivering')
          orderitem.update_attribute(:runner_id, current_user.id)
      elsif orderitem.status.eql?('delivering')
          orderitem.update_attribute(:status, 'complete')
      end
    end
    flash[:notice] = "Success!!"
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :price, :note)
    end
end
