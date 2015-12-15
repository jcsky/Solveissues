class RenameCreatorToOwnerToIssues < ActiveRecord::Migration
  def change
    rename_column :issues, :creator, :owner
  end
end
