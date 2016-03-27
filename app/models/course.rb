class Course < ActiveRecord::Base
  attr_accessible :college_id, :name, :professor, :year, :semester
  belongs_to :college
  has_many :videos
end