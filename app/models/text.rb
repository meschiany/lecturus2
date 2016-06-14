class Text < ActiveRecord::Base
  attr_accessible :video_id, :second, :user_id, :active, :description, :content

  belongs_to :videos
  belongs_to :user
end