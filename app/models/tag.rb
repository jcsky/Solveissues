class Tag < ActiveRecord::Base
  has_many :issue_tags
  has_many :issues, :through => :issue_tags
end
