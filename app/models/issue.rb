class Issue < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings

  belongs_to :user

  # Liked by users
  has_many :latest_issue_votes, dependent: :destroy
  has_many :liked_users, through: :latest_issue_votes, source: :user, dependent: :destroy

  def find_vote_by_user(user)
    self.votes.where(user_id: user.id).first
  end

  def like_by_user?(current_user)
    self.liked_users.include?(current_user)
  end

  def tag_list
    self.tags.map{ |x| x.name }
  end

  def tag_list=(arr)
    arr.delete_if{ |x| x.blank? }

    self.tags = arr.map do |t|
      tag = Tag.find_or_create_by(name: t)
    end
  end

end
