class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :monstar_id, default: 1
      t.integer :level, default: 1
      t.integer :hp, default: 10
      t.integer :ep, default: 0
      t.integer :physical, default: 0
      t.integer :intelligence, default: 0
      t.integer :lifestyle, default: 0
      t.integer :others, default: 0

      t.timestamps
    end
  end
end
