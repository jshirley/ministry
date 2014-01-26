class ProjectSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :tags, :current_status

  has_many :roles
  has_many :field_values, root: :content, key: "content"

  def roles
    # FIXME: If I just do object.roles it throws a Pg error for some reason
    Role.where("roles.project_id = ? AND roles.quantity > 0", object.id).to_a
  end

  def current_status
    object.status.name
  end

  def tags
    object.tag_list
  end

  def content
    fields = []

    # TODO: I'm not sure how to do this, but we don't want to include
    # all the user fields in ES I don't think.
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
