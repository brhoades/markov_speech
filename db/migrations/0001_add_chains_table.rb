class AddChainsTable < ActiveRecord::Migration
  def up
    create_table :chains do |t|
      t.integer :next, index: true
      t.integer :source_id, index: true
    end

    create_table :words do |t|
      t.string :text, index: true
    end

    create_table :sources do |t|
      t.string :text
    end
  end

  def down
    drop_table :chains
    drop_table :words
    drop_table :sources
  end
end
