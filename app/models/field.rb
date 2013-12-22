class Field < ActiveRecord::Base
  include RankedModel
  ranks :row_order

  has_many :field_values, inverse_of: :field

  validates :name, presence: true
  validates :description, presence: true
  validates :input_type, presence: true, inclusion: { in: %w(text textarea email range number phone) }

  validates :required, presence: true, inclusion: { in: [ true, false ] }

  # TODO: This needs to move into configuration
  def self.default_fields
    fields = []

    fields << Field.find_or_create_by!(
      name: "What is the purpose of the project",
      description: "Why is this project worth the effort?",
      required: true,
      input_type: "textarea"
    )

    fields << Field.find_or_create_by!(
      name: "How do you measure success?",
      description: "What does success look like and how will it be measured?",
      required: true,
      input_type: "textarea"
    )

    fields
  end
end
