class HistoricalIssueVote < ActiveRecord::Base
  serialize :liked_users
end
