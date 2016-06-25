class Post < ActiveRecord::Base
  attr_accessible :video_id, :second, :user_id, :active, :content, :content_type

  belongs_to :videos
  belongs_to :user
end