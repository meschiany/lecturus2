class College < ActiveRecord::Base
  attr_accessible :name
  has_many :courses
  has_many :videos, through: :course
end