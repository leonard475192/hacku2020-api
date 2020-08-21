class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.integer :user_id
      t.string :tag
      t.integer :level
      t.boolean :status, default:false

      t.timestamps
    end
  end
end
