class FieldValueSerializer < ActiveModel::Serializer
  attributes :name, :value
  has_one :user

  def name
    object.field.name
  end
end

