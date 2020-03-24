require "cashfree/version"
require 'rest-client'
require 'json'
module Cashfree
  class Error < StandardError; 
  	CONFIG_ERROR = "Token is not valid"
  	CONECTION_ERROR = "Couldn't connect to cashfree server"
  end
  
  class Payment
	  def initialize domain: , client_id:, client_secret: 
	  	@domain , @client_id, @client_secret = domain , client_id, client_secret
	  end


	  def validate_bank name: , phone: ,bankAccount: , ifsc: 
	  	authentication = authenticate
	  	if authentication["subCode"] =="200"
	  		token = authentication["data"]["token"]
	  		uri = '/payout/v1/validation/bankDetails'
	  		url = @domain+uri

			begin
				response = RestClient.get "#{@domain}#{uri}?#{URI.encode_www_form({name: name , phone: phone, bankAccount: bankAccount, ifsc: ifsc})}", {"Authorization" => "Bearer #{token}"}
			rescue  => e
				rescue Cashfree::Error::CONECTION_ERROR
			else
				return JSON.parse(response.body)
			end
	  	else
	  		raise Cashfree::Error::CONFIG_ERROR
	  	end
	  end

	  private 

	  def authenticate
	  	uri = "/payout/v1/authorize"
	  	url = @domain+uri
	  	begin 
	  		response = RestClient.post url ,'', {"X-Client-Id" => @client_id, "X-Client-Secret"=>@client_secret}
	  	rescue 
	  		rescue Cashfree::Error::CONECTION_ERROR
	  	else
	  		return JSON.parse(response.body)
	  	end
	  end

	   
	end
end
