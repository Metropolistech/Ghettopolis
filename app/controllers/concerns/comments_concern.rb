module CommentsConcern

  extend ActiveSupport::Concern

  @@keys = [:id, :content, :user, :created_at, :updated_at, :deleted_at]

  def create_comment(user: nil, data: {})
    return false if data.blank?

    initialize_comment
      .create_comment_uuid
      .insert_data_to_comment(data)
      .insert_user_to_comment(user)
  end

  def update_comment(comment: nil, data: {})
    return false unless comment or !data.blank?
    @comment = comment

    insert_data_to_comment(data)
      .update_updated_time
  end

  def destroy_comment(comment: nil)
    return false unless comment
    @comment = comment

    update_deleted_at
  end

  protected
    def initialize_comment
      @comment = Hash.new
      @comment[:created_at] = Time.new
      @comment[:updated_at] = @comment[:created_at]
      @comment[:deleted_at] = nil
      self
    end

    def create_comment_uuid
      @comment[:id] = SecureRandom.hex.to_sym
      self
    end

    def insert_data_to_comment(data)
      @comment[:content] = data[:content]
      self
    end

    def insert_user_to_comment(user)
      @comment[:user] = user.slice(:id, :username, :avatar)
      @comment
    end

    def update_updated_time
      @comment[:updated_at] = Time.new
      @comment
    end

    def update_deleted_at
      @comment[:deleted_at] = Time.new
      @comment
    end
end
