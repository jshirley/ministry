class Project < ActiveRecord::Base
  belongs_to :user, inverse_of: :projects
  belongs_to :status, inverse_of: :projects

  has_many :field_values, inverse_of: :project
  has_many :fields, through: :field_values

  has_many :roles, inverse_of: :project

  has_many :series_projects, inverse_of: :project
  has_many :series, through: :series_projects

  has_many :milestones, inverse_of: :project
  has_many :memberships, inverse_of: :project
  has_many :users, through: :memberships

  validates :user,   presence: true
  validates :status, presence: true

  validates :name, presence: true

  after_save :setup_default_fields

  private
  def setup_default_fields
    Field.default_fields.each do |field|
      self.field_values.create!(
        field: field,
        value: nil,
        user: self.user
      )
    end
  end
end
