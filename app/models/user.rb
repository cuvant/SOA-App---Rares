class User < ApplicationRecord
  # The default role set when a user is newly created
  # Is set to the first element from the following array [:user, :admin] (line 12)
  # In this case u = User.new, u.role = "user", even if 'role' column is integer
  #
  # Available methods:
  #
  # user.admin? true/false
  # user.user? true/false
  # user.admin! => sets user to role 'admin'
  # user.user! => sets user to role 'user'
  enum role: [:user, :admin]
  

  include TokenAuthenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook, :twitter, :instagram]

  before_save :ensure_authentication_token

  # mount_uploader :image, ImageUploader
  
  has_many :dashboards, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize.tap do |user|
      user = User.load_user_from_omniauth(user, auth)
    end
  end

  private

    def self.load_user_from_omniauth(user, auth)
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.email = auth.info.email if user.email.blank?
      user.email = auth.info.nickname + "@#{auth.provider}.com" if user.email.blank?
      user.password = Devise.friendly_token[0,20] if user.password.blank?
      user.remote_image_url = auth.info.image.gsub('http://','https://') if user.remote_image_url.blank?
      return user
    end

end
