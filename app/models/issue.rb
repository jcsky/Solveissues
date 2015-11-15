class Issue < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings

  belongs_to :user

  has_many :votes, :dependent => :destroy
  has_many :vote_users, through: :votes, source: :user, :dependent => :destroy
  acts_as_votable

  def find_vote_by_user(user)
    self.votes.where(user_id: user.id).first
  end

  def tag_list
    self.tags.map{ |x| x.name }
  end

  def tag_list=(arr)
    arr.delete_if{ |x| x.blank? }

    self.tags = arr.map do |t|
      tag = Tag.find_by_name(t)
      unless tag
        tag = Tag.create!( :name => t )
      end
      tag
    end
  end

end
