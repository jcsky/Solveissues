class IssueTag < ActiveRecord::Base
  belongs_to :tag, :counter_cache => :issue_count
  belongs_to :issue
end
