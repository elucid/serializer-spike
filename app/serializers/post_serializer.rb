class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :version

  belongs_to :author

  has_many :comments

  def version
    '0.10.0'
  end
end
