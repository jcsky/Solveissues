class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.integer :user_id
      t.string :party  #黨派
      t.string :job  #現職
      t.string :party_job  #黨職
      t.text :experience  #經歷
      t.string :election_position  #參選項目
      t.string :election_area  #參選選區
      t.timestamps null: false
    end
      add_index :information, :user_id
  end
end
