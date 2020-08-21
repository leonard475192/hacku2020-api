class Api::V1::TodosController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    # tokenある人だけ以下を実行できます
    before_action :authenticate
  
    def index
      todos = Todo.order(created_at: :desc)
      render json: { status: 'SUCCESS', message: 'loaded todos', data: todos }
    end
  
    def show
      todo = Todo.find(params[:id])
      render json: { status: 'SUCCESS', message: 'loaded the todo', data: todo }
    end
  
    def create
      todo = @auth_user.todo.build(todo_params)
      logger.debug("todo_params:::")
      logger.debug(todo_params)
      if todo.save
          render json: { status: 'SUCCESS', message: 'Todo was successfully created.', data: todo }
        else
          render json: { status: :unprocessable_entity, message: todo.errors }
        end
    end
  
    def destroy
      todo = Todo.find(params[:id])
      todo.destroy
      render json: { status: 'SUCCESS', message: 'deleted the todo', data: todo }
    end
  
    def update
      todo = Todo.find(params[:id])
      if todo.update(todo_params)
        render json: { status: 'SUCCESS', message: 'updated the todo', data: todo }
      else
        render json: { status: 'SUCCESS', message: 'loaded the todo', data: todo }
      end
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