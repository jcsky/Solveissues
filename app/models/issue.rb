class Issue < ActiveRecord::Base

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  has_many :issue_tags
  has_many :tags, :through => :issue_tags

  belongs_to :user

  # Liked by users
  has_many :issue_votes, dependent: :destroy
  has_many :liked_users, through: :issue_votes, source: :user, dependent: :destroy

  def liked_users_count
    self.liked_users.size
  end

  def find_vote_by_user(user)
    self.votes.where(user_id: user.id).first
  end

  def liked_by_user?(user)
    self.liked_users.include?(user)
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

  def liked_agents
    self.liked_users.where(:role =>1)
  end

  def owner_name
    if self.owner
      User.find(self.owner).name
    else
      "nil"
    end

  end

end
