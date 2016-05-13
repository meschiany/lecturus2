class Post < ActiveRecord::Base
  attr_accessible :video_id, :second, :user_id, :active, :description, :file_type, :file_name, :address

  belongs_to :videos
  belongs_to :user
end