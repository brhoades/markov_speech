class RenameNextColumn < ActiveRecord::Migration[5.0]
  def up
    rename_column :chains, :next, :next_id
  end

  def down
    rename_column :chains, :next_id, :next
  end
end
