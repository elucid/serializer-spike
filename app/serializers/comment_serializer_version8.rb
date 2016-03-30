class CommentSerializerVersion8 < ActiveModel::SerializerVersion8
  attributes :id, :text, :version

  has_one :post, embed: :ids, include: true

  def version
    '0.8'
  end
end
