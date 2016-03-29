class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :version

  def version
    '0.10.0'
  end
end
