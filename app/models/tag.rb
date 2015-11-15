class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :issues, :through => :taggings
end
