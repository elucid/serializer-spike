class PostSerializerVersion8 < ActiveModel::SerializerVersion8
  attributes :id, :title, :body, :version

  has_one :author, embed: :ids, include: true

  has_many :comments, embed: :ids, include: true

  def version
    '0.8'
  end
end
