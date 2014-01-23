class Field < ActiveRecord::Base
  include RankedModel
  ranks :row_order

  has_many :field_values, inverse_of: :field

  validates :name, presence: true
  validates :description, presence: true
  validates :input_type, presence: true, inclusion: { in: %w(text textarea email range number phone) }

  validates :required, inclusion: { in: [ true, false ] }

  # TODO: This needs to move into configuration
  def self.default_fields
    fields = []

    fields << Field.find_or_create_by!(
      name: "What is the purpose of the project",
      description: "Why is this project worth the effort? What is its importance?",
      required: true,
      input_type: "textarea",
      retrospective: false,
    )

    fields << Field.find_or_create_by!(
      name: "How will we measure success?",
      description: "What does success look like and how will it be measured?",
      required: true,
      input_type: "textarea",
      retrospective: false,
    )

    fields << Field.find_or_create_by!(
      name: "What is the worst that can happen?",
      description: "What could go wrong? Try to put yourself at the end of the project, imagine it is over and everything went wrong. It could not have been worse. Now, what happened?",
      required: true,
      input_type: "textarea",
      retrospective: false,
    )

    fields << Field.find_or_create_by!(
      name: "How did it go?",
      description: "Did the project launch ok? Any important notes or key take-aways?",
      required: false,
      input_type: "textarea",
      retrospective: true,
    )

    fields
  end
end
