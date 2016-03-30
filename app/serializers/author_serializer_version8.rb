class AuthorSerializerVersion8 < ActiveModel::SerializerVersion8
  attributes :id, :name, :version

  has_many :posts, embed: :ids, include: true

  def version
    '0.8'
  end
end
