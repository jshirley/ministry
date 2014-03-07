class Project < ActiveRecord::Base
  include AASM, ProjectSearch

  # Sets up :tag_list, :tags
  acts_as_taggable

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

    # tags and statuses are atoms, so there's no reason
    # to analyze them
    indexes :tags,           :index => :not_analyzed
    indexes :current_status, :index => :not_analyzed
  end

  def to_indexed_json
    # acts-as-taggable-on requires a reload for tags to be here
    self.reload
    ProjectSerializer.new(self).to_json
  end

  # Relationships
  belongs_to :user, inverse_of: :projects
  belongs_to :status, inverse_of: :projects

  has_many :field_values, inverse_of: :project, dependent: :destroy
  has_many :fields, through: :field_values
  accepts_nested_attributes_for :field_values

  has_many :roles, inverse_of: :project, dependent: :destroy

  has_many :series_projects, inverse_of: :project, dependent: :destroy
  has_many :series, through: :series_projects

  has_many :milestones, inverse_of: :project, dependent: :destroy
  has_many :memberships, inverse_of: :project, dependent: :destroy
  has_many :users, through: :memberships

  # Validations
  validates :user,   presence: true
  validates :status, presence: true
  validates :name,   presence: true
  validates :public, inclusion: { in: [ true, false ] }

  # Callbacks
  after_create :setup_default_fields

  # State Machine for status transitions
  aasm_column :aasm_state

  aasm do
    state :pending, initial: true
    state :staffing
    state :scheduled
    state :working
    state :succeeded
    state :failed
    state :abandoned

    event :staff do
      transitions from: :pending, to: [ :staffing, :abandoned ]
    end

    event :schedule do
      transitions from: :staffing, to: [ :scheduled, :abandoned ], guard: :is_staffed?
    end

    event :work do
      transitions from: :scheduled, to: [ :working, :abandoned ]
    end

    event :succeed do
      transitions from: :working, to: :succeeded
    end

    event :fail do
      transitions from: :working, to: :failed
    end

    event :abandon do
      transitions from: [ :pending, :staffing, :scheduled, :working ], to: :abandoned
    end
  end

  # Object methods

  # Public: Return a list of Roles that are not fully staffed
  # Returns a result set of Roles
  def unfilled_roles
    role_to_quantity = {}
    self.roles.each do |role|
      role_to_quantity[role.id] = role.quantity
    end

    self.memberships.active.select("memberships.role_id, COUNT(*) as count").group("role_id").each do |record|
      if record.count >= role_to_quantity[record.role_id]
        role_to_quantity.delete(record.role_id)
      end
    end

    self.roles.where("id IN (:ids)", ids: role_to_quantity.keys)
  end

  # Public: Determines if the project is fully staffed
  # Returns boolean true if staffed entirely
  def is_staffed?
    self.unfilled_roles.count == 0
  end

  private
  def setup_default_fields
    return if self.field_values.size > 0

    Field.default_fields.each do |field|
      record = self.field_values.build(
        field_id: field.id,
        value: nil,
        user: self.user
      )
      # Value will be null, so we will skip validation on default.
      record.save!(validate: false)
    end
  end
end
