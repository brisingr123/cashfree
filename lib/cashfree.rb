require "cashfree/version"
require 'rest-client'
require 'json'
module Cashfree
  class Error < StandardError; end
  
  class Payment
	  def initialize domain: , client_id:, client_secret: 
	  	@domain , @client_id, @client_secret = domain , client_id, client_secret
	  end


	  def validate_bank name: , phone: ,bankAccount: , ifsc: 
	  	authentication = authenticate
	  	if authentication["status"] =="SUCCESS"
	  		token = authentication["token"]

	  		uri = '/payout/v1/validation/bankDetails'
	  		url = @domain+uri

	  		begin 
				response = RestClient.get url , {"Authorization" => "Bearer #{token}"}	  		
			rescue RestClient::CashfreeError => err
				return "Couldn't connect to cashfree"
			else
				return JSON.parse(response.body)
			end
	  	else
	  		puts "Configuration mismatch"
	  	end
	  end

	  private 

	  def authenticate
	  	uri = "/payout/v1/authorize"
	  	url = @domain+uri
	  	begin 
	  		response = RestClient.get url , {"X-Client-Id" => @client_id, "X-Client-Secret"=>@client_secret}
	  	rescue RestClient::CashfreeError => err
	  		return "Couldn't connect to cashfree"
	  	else
	  		return JSON.parse(response.body)
	  	end
	  end

	   
	end
end
