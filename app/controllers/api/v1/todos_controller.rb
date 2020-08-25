class Api::V1::TodosController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    # tokenある人だけ以下を実行できます
    before_action :authenticate
  
    def index
      todos = Todo.where(user_id: @auth_user.id).order(created_at: :desc)
      render json: { status: 'SUCCESS', message: 'loaded todos', data: todos }
    end
  
    def show
      todo = Todo.find(params[:id])
      if todo.user_id ==  @auth_user.id then
        render json: { status: 'SUCCESS', message: 'loaded the todo', data: todo }
      else
        render json: { status: 'BAD REQUEST', message: 'this is not your todo'}
      end
    end
  
    def create
      todo = @auth_user.todo.build(todo_params)
      logger.debug("todo_params:::")
      logger.debug(todo_params)
      if todo.save
          render json: { status: 'SUCCESS', message: 'Todo was successfully created.', data: todo}
        else
          render json: { status: :unprocessable_entity, message: todo.errors }
        end
    end
  
    def destroy
      todo = Todo.find(params[:id])
      if todo.user_id ==  @auth_user.id then
        todo.destroy
        render json: { status: 'SUCCESS', message: 'deleted the todo'}
      else
        render json: { status: 'BAD REQUEST', message: 'this is not your todo'}
      end
    end

    def destroy_all
      ids = params[:id]
      data = Hash.new
      for id in ids
        todo = Todo.find(id)
        if todo.user_id ==  @auth_user.id then
          todo.destroy
          cell = { id => { 'status' => 'SUCCESS', 'message' => 'deleted the todo'}}
          data.merge!(cell)
        else
          cell = {id => { 'status' => 'BAD REQUEST', 'message' => 'this is not your todo'}}
          data.merge!(cell)
        end
      end
      render json: data.to_json
    end
  
    def update
      todo = Todo.find(params[:id])
      if todo.user_id ==  @auth_user.id then
        if todo.update(todo_params)
          render json: { status: 'SUCCESS', message: 'updated the todo', data: todo }
        else
          render json: { status: 'SUCCESS', message: 'loaded the todo', data: todo }
        end
      else
        render json: { status: 'BAD REQUEST', message: 'this is not your todo'}
      end
    end

    def complete
      ids = params[:id]
      data = Hash.new
      physical = 0
      ep = [0,0,0,0]
      getep = 0
      for id in ids do
        todo = Todo.find(id)
        if todo.user_id ==  @auth_user.id then
          if todo.status == false
            # TODO完了処理
            todo.status = true
            todo.save
            # パラメータ処理
            case todo.tag
            when "physical"
              ep[0] +=  todo.level
            when "intelligence"
              ep[1] +=  todo.level
            when "lifestyle"
              ep[2] +=  todo.level
            when "others"
              ep[3] +=  todo.level
            else
            end
          else
            cell = {id => { 'status' => 'BAD REQUEST', 'message' => 'already done the todo'}}
            data.merge!(cell)
          end
        else
          cell = {id => { 'status' => 'BAD REQUEST', 'message' => 'this is not your todo'}}
          data.merge!(cell)
        end
      end
      # 経験値処理
      @auth_user.physical += ep[0]
      @auth_user.intelligence += ep[1]
      @auth_user.lifestyle += ep[2]
      @auth_user.others += ep[3]
      for p in ep
         getep += p
      end
      @auth_user.ep += getep
      # LvUP処理
      if @auth_user.ep >= @auth_user.level * 5
        @auth_user.ep -= @auth_user.level * 5
        @auth_user.level += 1
        case @auth_user.level
        when 2
          @auth_user.monster_id = 2
        when 3
          if @auth_user.physical > 10
            @auth_user.monster_id = 3
          elsif @auth_user.intelligence > 10
            @auth_user.monster_id = 4
          elsif @auth_user.lifestyle > 10
            @auth_user.monster_id = 5
          else
            @auth_user.monster_id = 6
          end
        end
      end
      @auth_user.save
      monster = Monster.find(@auth_user.monster_id)
      # ここから、成功時のレスポンス
      cell = { 'status' => 'SUCCESS', 'message' => 'geted exp', 'data' => @auth_user, 'img' => monster.img}
      data.merge!(cell)
      render json: data.to_json
    end
    
  
      private
      def authenticate
        authenticate_or_request_with_http_token do |token,options|
          @auth_user = User.find_by(token: token)
          @auth_user != nil ? true : false
        end
      end
  
      def todo_params
        params.require(:todo).permit(:title, :explanation, :tag, :level)
      end
end