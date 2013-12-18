class Project < ActiveRecord::Base
  acts_as_taggable

  def self.matched_to_user(user)
    u = user
    Project.tire.search { filter :terms, tags: u.skill_list }
  end

  after_touch {
    tire.update_index
  }

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :name, type: 'string', boost: 10, analyzer: 'snowball'
    indexes :roles do
      indexes :name, analyzer: 'snowball'
    end
  
    # tags are atoms, so there's no reason
    # to analyze them
    indexes :tags, :index    => :not_analyzed
  end

  def to_indexed_json
  #   # acts-as-taggable-on requires a reload for tags to be here
    # self.reload
    ProjectSerializer.new(self).to_json
  end

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

  def unfilled_roles
    role_to_quantity = {}
    self.roles.each do |role|
      role_to_quantity[role.id] = role.quantity
    end

    self.memberships.select("memberships.role_id, COUNT(*) as count").group("role_id").each do |record|
      if record.count >= role_to_quantity[record.role_id]
        role_to_quantity.delete(record.role_id)
      end
    end

    self.roles.where("id IN (:ids)", ids: role_to_quantity.keys)
  end 

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
