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
end
