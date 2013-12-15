class Project < ActiveRecord::Base
  belongs_to :user, inverse_of: :projects
  belongs_to :status, inverse_of: :projects

  has_many :roles, inverse_of: :project

  has_many :series_projects, inverse_of: :project
  has_many :series, through: :series_projects

  has_many :milestones, inverse_of: :project
  has_many :memberships, inverse_of: :project
  has_many :users, through: :memberships

  validates :user,   presence: true
  validates :status, presence: true

  validates :name, presence: true
end
