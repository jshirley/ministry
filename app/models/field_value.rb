class FieldValue < ActiveRecord::Base
  belongs_to :project, inverse_of: :field_values, touch: true
  belongs_to :field, inverse_of: :field_values

  belongs_to :user

  validates :project, presence: true
  validates :field, presence: true

  validates_presence_of :value, if: :is_field_required?

  scope :populated, -> { includes(:field).where("field_values.value IS NOT NULL").order("fields.row_order").references(:field) }

  def is_field_required?
    field.required
  end
end
