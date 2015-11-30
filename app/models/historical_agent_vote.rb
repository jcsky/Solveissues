class HistoricalAgentVote < ActiveRecord::Base
  serialize :liked_users
  serialize :disliked_users
end
