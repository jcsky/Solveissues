class Issue < ActiveRecord::Base


  has_many :votes, :dependent => :destroy
  has_many :vote_users, through: :votes, source: :user, :dependent => :destroy
  acts_as_votable

  def find_vote_by_user(user)
    self.votes.where(user_id: user.id).first
  end


end
