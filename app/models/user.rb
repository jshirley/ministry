class User < ActiveRecord::Base
  acts_as_taggable_on :skills

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [ :github ]

  after_create :find_orphaned_memberships

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = User.create(
        name:  auth.extra.raw_info.name,
        uid:   auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20],
        provider: auth.provider
      )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  has_many :projects, inverse_of: :user
  has_many :obstacles, inverse_of: :user
  has_many :series, inverse_of: :user
  has_many :memberships, inverse_of: :user
  has_many :milestones, inverse_of: :user
  has_many :contributing_projects, through: :memberships, source: :project

  def display_name
    if self.name.blank?
      return self.email
    end
    self.name
  end

  private
  def find_orphaned_memberships
    Membership.where(user_id: nil, email: self.email).update_all(user_id: self.id)
  end
end
