class Role < ActiveRecord::Base
  belongs_to :project, inverse_of: :roles, touch: true

  has_many :memberships, inverse_of: :role
  has_many :users, through: :memberships

  validates :project, presence: true

  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def self.default_role_names
    [ 'Product Manager', 'Developer', 'Documenter', 'Tester', 'Evangelist' ]
  end

  def pending_for(user)
    memberships.where(user: user, approved: false, accepted: false, active: true)
  end

  # Determine if a user can apply, based on if they have a pending membership
  # or if the project is public.
  def can_apply?(user)
    return true
  end
end
