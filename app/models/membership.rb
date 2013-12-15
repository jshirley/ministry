class Membership < ActiveRecord::Base
  belongs_to :project, inverse_of: :memberships
  belongs_to :user, inverse_of: :memberships
  belongs_to :role, inverse_of: :memberships

  validates :project, presence: true
  validates :role,    presence: true

  # User may be null, but email can't be
  # TODO: email validation?
  validates :email, presence: true
end
