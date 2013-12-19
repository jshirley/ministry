class ProjectSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :content, :tags
  has_many :users, :roles

  def tags
    object.tag_list
  end

  def content
    fields = []

    object.field_values.includes(:field, :user).where({}).each do |value|
      next if value.value.blank?
      fields << {
        name: value.field.name,
        value: value.value,
        user: value.user
      }
    end

    fields
  end
end
