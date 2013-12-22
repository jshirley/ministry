class FieldValue < ActiveRecord::Base
  belongs_to :project, inverse_of: :field_values, touch: true
  belongs_to :field, inverse_of: :field_values

  belongs_to :user

  validates :project, presence: true
  validates :field, presence: true

  validates_presence_of :value, if: :is_field_required?

  def is_field_required?
    field.required
  end
end
