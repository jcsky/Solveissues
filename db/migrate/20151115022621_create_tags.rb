class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.integer :issue_count, null: false, default: 0
      t.timestamps null: false
    end
    add_index :tags, :issue_count
  end
end
