class OrderitemsController < ApplicationController
  before_action :set_orderitem, only: [:show, :edit, :update, :destroy]

  # GET /orderitems
  # GET /orderitems.json
  def index
    @orderitems = Orderitem.all
  end

  # GET /orderitems/1
  # GET /orderitems/1.json
  def show
  end

  # GET /orderitems/new
  def new
    @item = Item.find(params[:item_id])
    @orderitem = Orderitem.new
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
        format.html { redirect_to @orderitem, notice: 'Orderitem was successfully created.' }
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
        format.html { redirect_to @orderitem, notice: 'Orderitem was successfully updated.' }
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
      format.html { redirect_to '/customer', notice: 'Orderitem was successfully canceled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orderitem
      @orderitem = Orderitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orderitem_params
      params.require(:orderitem).permit(:quantity, :note, :total, :status, :item_id, :user_id)
    end

end
