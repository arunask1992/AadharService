class UsersController < ApplicationController
  @otp_url = "https://ac.khoslalabs.com/hackgate/hackathon/otp"
  def auth
    @user = User.where(aadhar_id: params[:id]).take
    if @user
      render json: {status: 'OK', user: @user}
    else
      body_val = { "aadhaar-id" => params[:id], "device-id" => "192.168.0.101", "channel" => "SMS", "certificate-type" => "preprod", "location" => {"type" => "pincode", "pincode" => params[:pin]}}
      p body_val.to_json
      returned_value = HTTParty.post("https://ac.khoslalabs.com/hackgate/hackathon/otp",
                                     {
                                         :body =>  body_val.to_json,
                                         :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                                     })
      render json: {status: 'OK', otp: returned_value }
    end
  end

  def adduser
    user_object = HttParty.post("https://ac.khoslalabs.com/hackgate/hackathon/kyc/raw",{
        :body => 
    })
  end
end
