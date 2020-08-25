class RenameMonstarIdColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :monstar_id, :monster_id
  end
end
