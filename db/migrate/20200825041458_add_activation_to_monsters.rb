class AddActivationToMonsters < ActiveRecord::Migration[6.0]
  def change
    add_column :monsters, :img, :text
  end
end
