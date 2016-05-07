class User < ActiveRecord::Base
  attr_accessible :email, :f_name, :l_name, :college_id, :password, :last_login_timestamp, :token
  has_many :contents
  has_many :videos
  has_many :courses, through: :video
end