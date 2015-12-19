class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Liked issues of user
  has_many :issue_votes, dependent: :destroy
  has_many :like_issues, through: :issue_votes, source: :issue, dependent: :destroy
  has_many :agent_votes, :dependent => :destroy
  has_many :vote_to_agents, :through => :agent_votes, :source => :agent
  has_many :election_records
  has_many :issues, :foreign_key => "owner"
  has_one :information, :dependent => :destroy
  has_one :record,:foreign_key => "agent_id", :dependent => :destroy

  accepts_nested_attributes_for :information, :allow_destroy => true, :reject_if => :all_blank
  has_attached_file :photo, :styles => { :large => "600x600>", :medium => "300x300>", :small => "250x250>", :thumb => "100x100>",:special => "70x70>" }, :default_url => "/images/:style/missing.png"
  # :path => ":rails_root/public/system/menus/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  scope :agents, -> { where(role: 1) }

  def agent?
    self.role == 1
  end

  def toggle_like(issue)
    if self.like_issue?(issue)
      self.like_issues.delete(issue)
    else
      self.like_issues << issue
    end
  end

  def like_issue?(issue)
    self.like_issues.include?(issue)
  end

  def user_name
    if self
       self.name || self.email.split("@").first
    else
      "Guest"
    end
  end

  def self.record_count
    User.agents.each do |agent|
      record = Record.find_by_agent_id(agent.id) || Record.create(:agent_id => agent.id)
      rep_yes = AgentVote.where(:agent_id => agent.id, :value => 1).count
      rep_no = AgentVote.where(:agent_id => agent.id, :value => -1).count
      record.update(:user_like => rep_yes)
      record.update(:user_dislike => rep_no)
      record.update(:reputation => rep_yes - rep_no)
      record.save!
    end
  end

  def reputation
    record = Record.find_by_agent_id(self.id) || Record.create(:agent_id => self.id)
    record.reputation
  end

  def user_like_count
    self.record.user_like
  end

  def user_dislike_count
    self.record.user_dislike
  end

  def self.same_issue_ids(user1, user2)
    user1.like_issues.pluck(:id) & user2.like_issues.pluck(:id)
  end

  def self.from_omniauth(auth)
    where(fb_uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.fb_uid = auth.uid
     user.password = Devise.friendly_token[0,20]
     user.name = auth.info.name
     user.fb_image = auth.info.image
     user.gender = auth.extra.raw_info.gender
     user.birthday = auth.info.birthday
     user.register_homecity = auth.info.hometown
     user.fb_access_token = auth.credentials.token
     logger.info auth
    end
  end

  def self.get_fb_data(access_token)
    conn = Faraday.new(:url => 'https://graph.facebook.com')
    res = conn.get '/v2.5/me', { :access_token => access_token }
    if res.status == 200
      JSON.parse( res.body )
    else
      Rails.logger.warn(res.body)
      nil
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def generate_authentication_token
    token = nil

    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end

    self.authentication_token = token
  end

end
