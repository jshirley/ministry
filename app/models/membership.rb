class Membership < ActiveRecord::Base
  belongs_to :project, inverse_of: :memberships, touch: true
  belongs_to :user, inverse_of: :memberships
  belongs_to :role, inverse_of: :memberships

  validates :project, presence: true
  validates :role,    presence: true

  # User may be null, but email can't be
  # TODO: email validation?
  validates :email, presence: true

  after_destroy :fix_counter_cache
  after_save :fix_counter_cache, :if => ->(er) { er.new_record? or er.role_id_changed? }

  scope :active, -> { where(accepted: true, approved: true) }

  private
  def fix_counter_cache
    # TODO: Bypassing increment/decrement counter, should stop that.
    # this needs to be optimized a lot better.
    unless self.role_id_was.nil?
      old_role = self.project.roles.find(self.role_id_was)
      old_role.update_attributes(filled_count: old_role.memberships.active.count)
    end

    new_role = self.project.roles.find(self.role_id)
    new_role.update_attributes(filled_count: new_role.memberships.active.count)
  end
end
