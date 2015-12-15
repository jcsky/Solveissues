class AddPaperclipToIssue < ActiveRecord::Migration
  def change
    add_attachment :issues, :logo
  end
end
