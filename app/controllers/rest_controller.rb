class RestController < ApplicationController
    require 'rest-client'

    skip_before_action :verify_authenticity_token
    def sendRequest
        data = {
            "externalCode": params[:id],
            "storeId":  params[:store_id],
            "subTotal": params[:total_amount],
            "deliveryFee": params[:total_shipping],
            "total_shipping": params[:total_shipping],
            "total": params[:total_amount_with_shipping],
            "country": params[:shipping][:receiver_address][:country][:id],
            "state": params[:shipping][:receiver_address][:state][:name],
            "city": params[:shipping][:receiver_address][:city][:name],
            "district": params[:shipping][:receiver_address][:neighborhood][:name],
            "street": params[:shipping][:receiver_address][:street_name],
            "complement":  params[:shipping][:receiver_address][:comment],
            "latitude": params[:shipping][:receiver_address][:latitude],
            "longitude": params[:shipping][:receiver_address][:longitude],
            "dtOrderCreate": params[:shipping][:date_created],
            "postalCode": params[:shipping][:receiver_address][:zip_code],
            "number": params[:shipping][:receiver_address][:street_number],
            "customer": {
                "externalCode": params[:buyer][:id],
                "name": params[:buyer][:nickname],
                "email": params[:buyer][:email],
                "contact": "#{params[:buyer][:phone][:area_code]}#{params[:buyer][:phone][:number]}"
            },
            "items": [],
            "payments": []
        }
        for order_items in params[:order_items]
            data[:items].push({
                "externalCode": order_items[:item][:id],
                "name": order_items[:item][:title],
                "price": order_items[:unit_price],
                "quantity": order_items[:quantity],
                "total": order_items[:full_unit_price],
                "subItems": []
            })
        end
        for pay in params[:payments]
            data[:payments].push({
                "type": pay[:payment_type],
                "value": pay[:total_paid_amount]
            })
        end
    
        begin
            res = RestClient.post(
                "https://delivery-center-recruitment-ap.herokuapp.com/", 
                data.to_json, 
                {content_type: :json, accept: :json, 'X-Sent': Time.new.strftime("%kh%M - %d/%m/%Y")}
            )
        rescue => e
            render :json => {:response => e.response },:status => e.initial_response_code
        end 
    
        render :json => {:response => res.body },:status => 200
    end
end