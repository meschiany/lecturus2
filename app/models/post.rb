class Post < ActiveRecord::Base
  attr_accessible :video_id, :second, :user_id, :post_type, :active, :text, :f_type, :f_name
  belongs_to :videos
  belongs_to :user
end