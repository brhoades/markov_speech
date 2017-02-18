class AddWordToChains < ActiveRecord::Migration[5.0]
  def up
    add_column :chains, :word_id, :integer, index: true
  end

  def down
    remove_column :chains, :word
  end
end
