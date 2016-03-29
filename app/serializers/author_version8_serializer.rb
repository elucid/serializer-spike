class AuthorVersion8Serializer < ActiveModel::Serializer
  attributes :id, :name, :version

  def version
    '0.8'
  end
end
