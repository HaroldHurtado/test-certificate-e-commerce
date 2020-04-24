class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
      @items = OrderItem.where(order_id: @order.id)
  end

  # GET /orders/new
  def new
    @order = Order.new
    @items = Item.all
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @items = Item.all
    @order = Order.new()
    @order.desccription = order_params[:desccription]
    total_items = 0
    order_items_attributes = order_params[:order_items_attributes]

    if order_items_attributes || order_items_attributes.count == 0
        order_items_attributes.each do |item|
            total_items += item['quantity'].to_i
        end
    end

    respond_to do |format|
        if total_items > 0
            if @order.save

               if order_items_attributes
                   order_items_attributes.each do |item|
                       logger.info "=================================="
                       logger.info item
                       logger.info "=================================="
                       name = item['name'].to_s
                       description = item['description'].to_s
                       image_url = item['image_url'].to_s
                       quantity = item['quantity'].to_i
                       price = item['price'].to_f
                       price_total = 0

                       if quantity != nil && price != nil
                           price_total = quantity * price
                       end
                       OrderItem.create(name: name, description: description, image_url: image_url, quantity: quantity, price: price_total, order_id: @order.id)
                   end

               end

               require 'mercadopago.rb'
                mp = MercadoPago.new(ENV['ACCESS_TOKEN'])
                payer = {
                    name: "test_user_63274575@testuser.com",
                    surname: "test_user_63274575@testuser.com",
                    email: "test_user_63274575@testuser.com",
                }

                send_items = []
                total_payment = 0
                order_items_attributes.each do |item|
                    name = item['name'].to_s
                    quantity = item['quantity'].to_i
                    price = item['price'].to_f

                    if quantity> 0
                        send_items << {
                            "title": name,
                            "quantity": quantity,
                            "unit_price": price,
                            "currency_id": "ARS"
                        }
                    end

                end

                logger.info "=========="
                logger.info ENV['ENVIRONMENT_BASE_URL']
                logger.info "=========="
                back_urls = {
                    "success": ENV['ENVIRONMENT_BASE_URL']+"/order_success?order_id="+@order.id.to_s,
                    "pending": ENV['ENVIRONMENT_BASE_URL']+"/order_pending?order_id="+@order.id.to_s,
                    "failure": ENV['ENVIRONMENT_BASE_URL']+"/order_failure?order_id="+@order.id.to_s
                    }
                auto_return = 'approved'

                preference_data = {
                    "payer": payer,
                    "items": send_items,
                    "payment_methods": {
                        "excluded_payment_types": [
                            {"id":"ticket"},
                            {"id":"atm"}
                        ]
                    },
                    "back_urls": back_urls,
                    "auto_return": auto_return
                }

                logger.info "==============================================="
                logger.info preference_data
                logger.info "==============================================="

                preference = mp.create_preference(preference_data)
                preference_response = preference['response']

                logger.info "===================================="
                logger.info preference
                logger.info "===================================="

                message = ""
                if preference_response["id"] == nil && preference_response["id"] == ""
                      message = "No se pudo crear la orden en MercadoPago"
                else
                    message = "Se realizo con exito la orden en MercadoPago"
                    Preference.create(preference_id: preference_response["id"], order_id: @order.id)
                end


              format.html { redirect_to @order, notice: message }
              format.json { render :show, status: :created, location: @order }
            else
              format.html { render :new }
              format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        else
             @order.errors.add(:order_items, "Para realizar la compra, almenos un producto tiene que tener valor mayor que 0 (cero)")
            format.html { render :new }
            format.json { render json: @order.errors, status: :unprocessable_entity }
        end

    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
      @items = Item.all
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
      @items = Item.all
      OrderItem.where(order_id: @order.id).destroy_all
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def order_success
      render :order_success
  end

  def order_pending
      render :order_pending
  end

  def order_failure
      render :order_failure
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:desccription, order_items_attributes: [:id, :name, :description, :image_url , :price, :quantity])
    end
end
