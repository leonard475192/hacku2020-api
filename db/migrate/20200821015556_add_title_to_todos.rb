class AddTitleToTodos < ActiveRecord::Migration[6.0]
  def change
    add_column :todos, :title, :string
    add_column :todos, :explanation, :text
  end
end
