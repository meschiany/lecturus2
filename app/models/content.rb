class Content < ActiveRecord::Base
  attr_accessible :video_id, :second, :user_id, :type, :active, :text, :f_type, :f_name
  belongs_to :videos
  belongs_to :user
end