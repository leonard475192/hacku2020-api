class Api::V1::LoginController < ApplicationController
  def login
    login_user = User.find_by(name:params[:name], password:params[:password])
    if login_user != nil
      render json: { status: 'SUCCESS', message: 'user logged in', data: login_user }
    else
      render json: { status: 'FAILER', message: 'no auth' }
    end
  end
end