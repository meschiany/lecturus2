class Video < ActiveRecord::Base
  attr_accessible :title, :master_id, :start_record_timestamp, :end_record_timestamp, :course_id, :length, :status
  has_many :contents
  belongs_to :course
  belongs_to :user,  foreign_key: "master_id"
end
