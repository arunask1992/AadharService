class UsersController < ApplicationController
  @otp_url = "https://ac.khoslalabs.com/hackgate/hackathon/otp"
  def auth
    @user = User.where(aadhar_id: params[:id]).take
    if @user
      render json: {status: 'OK', user: @user}
    else
      @user = User.create(:aadhar_id => params[:id], :pincode => params[:pin])
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
    @user = User.where(aadhar_id: params[:id]).take
    if @user
      render json: {status: 'OK', user: @user}
    end
    user_object = HTTParty.post("https://ac.khoslalabs.com/hackgate/hackathon/kyc/raw",{
        :body => {"consent" => "Y", "auth-capture-request" =>  {"aadhaar-id" => params[:id], "device-id" => "192.168.0.101", "modality" => "otp", "otp" => params[:otp],"certificate-type" => "preprod","location"=> { "type" => "pincode", "pincode" => @user.pincode}}}.to_json,
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
    })
    p user_object.inspect
    @user.name = user_object['kyc']['poi']['name']
    @user.date_of_birth = user_object['kyc']['poi']['dob']
    @user.gender = user_object['gender']
    address_data = user_object['kyc']['poa']
    if address_data
      @user.address = address_data['street'] + "," + address_data['dist'] + "," + address_data['state'] + "," + address_data['po'] + "Pin- " + address_data['pc']
    end
    @user.photo = user_object['kyc']['photo']
    @user.save
    p user_object.inspect
    render json: {status: '201', user: user_object}
  end
end
