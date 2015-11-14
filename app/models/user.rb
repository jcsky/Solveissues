class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :votes, :dependent => :destroy
  has_many :vote_issues, through: :votes, source: :issue, :dependent => :destroy
  has_many :election_records

  has_attached_file :photo, :styles => { :large => "600x600>", :medium => "300x300>", :small => "250x250>", :thumb => "100x100>",:special => "70x70>" }, :default_url => "/images/:style/missing.png"
  # :path => ":rails_root/public/system/menus/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  acts_as_voter
  acts_as_votable

  def self.from_omniauth(auth)
    where(fb_uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.fb_uid = auth.uid
     user.password = Devise.friendly_token[0,20]
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

  def user_name
    if self
       self.name || self.email.split("@").first
    else
      "Guest"
    end
  end
end
