class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    users = User.order(created_at: :desc)
    render json: { status: 'SUCCESS', message: 'loaded users', data: users }
  end

  def show
    user = User.find(params[:id])
    render json: { status: 'SUCCESS', message: 'loaded the user', data: user }
  end

  def create
    user = User.new(user_params)
    monster = Monster.find(user.monster_id)
    if user.save
      render json: { status: 'SUCCESS', message: 'User was successfully created.', data: user, img: monster}
    else
      render json: { status: :unprocessable_entity, message: user.errors }
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { status: 'SUCCESS', message: 'deleted the user', data: user }
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { status: 'SUCCESS', message: 'updated the user', data: user }
    else
      render json: { status: 'SUCCESS', message: 'loaded the user', data: user }
    end
  end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :token)
    end

    def encode_base64(image_file)
      image = Base64.encode64(image_file.download) # 画像ファイルをActive Storageでダウンロードし、エンコードする
      blob = ActiveStorage::Blob.find(image_file[:id]) # Blobを作成
      "data:#{blob[:content_type]};base64,#{image}" # Vue側でそのまま画像として読み込み出来るBase64文字列にして返す
    end
end