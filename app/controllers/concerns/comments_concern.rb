module CommentsConcern
  extend ActiveSupport::Concern

  def create_comment(user: nil, data: {})
    return false unless user or !data.blank?
    comment = initialize_comment
    comment[:id] = @uuid
    comment[:content] = data[:content]
    comment[:user] = user
    comment
  end

  def update_comment(comment: nil, data: {})
    return false unless comment or !data.blank?
    comment["content"] = data[:content]
    comment
  end

  private

  def initialize_comment
    @uuid = SecureRandom.hex.to_sym
    hash = Hash.new
  end
end
