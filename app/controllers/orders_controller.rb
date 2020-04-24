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
    @order.description = order_params[:description]
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
                       id = item['id'].to_s
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
                    name: "Lola",
                    surname: "Landa",
                    identification: {
                        type: "DNI",
                        number: "22.333.444"
                    },
                    email: "test_user_63274575@testuser.com",
                    phone: {
                        area_code: "011",
                        number: "2222-3333"
                    },
                    address: {
                        street_name: "Falsa",
                        street_number: 123,
                        zip_code: "1111"
                    }

                }

                send_items = []
                total_payment = 0
                order_items_attributes.each do |item|
                    id = item['name'].to_s
                    name = item['name'].to_s
                    image_url = item['image_url'].to_s
                    quantity = item['quantity'].to_i
                    price = item['price'].to_f

                    if quantity> 0
                        send_items << {
                            "id": id,
                            "title": name,
                            "description": "Dispositivo móvil de Tienda e-commerce",
                            "picture_url": image_url,
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
                            {"id":"amex"},
                            {"id":"atm"}
                        ],
                        "installments": 6,
                        "default_installments": 6
                    },
                    "back_urls": back_urls,
                    "auto_return": auto_return,
                    "notification_url": ENV['ENVIRONMENT_BASE_URL']+"/order_notification",
                    "external_reference": @order.id.to_s
                }

                preference = mp.create_preference(preference_data)
                preference_response = preference['response']

                logger.info "================================"
                logger.info "================================"
                logger.info "================================"
                logger.info preference_response
                logger.info "================================"
                logger.info "================================"
                logger.info "================================"


                message = ""
                if preference_response["status"] == 401 || preference_response["status"] == "401"
                    message = preference_response["message"]
                    error = preference_response["error"]
                    Preference.create(preference_id: message+" "+error, order_id: @order.id)
                else
                    if preference_response["id"] == nil && preference_response["id"] == ""
                          message = "Preference ID, es nulo"
                          if preference_response["status"] == 401 || preference_response["status"] == "401"
                                Preference.create(preference_id: message, order_id: @order.id)
                          end
                    else
                        Preference.create(preference_id: preference_response["id"], order_id: @order.id)
                    end
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

  def order_failure
      render :order_failure
  end

  def order_notification
      logger.info "==================Start order_notification======================="
      logger.info "==================End order_notification======================="
      format.json {status: :ok}
      # OR
      #format.json {status: :created}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:description, order_items_attributes: [:id, :name, :description, :image_url , :price, :quantity])
    end
end
