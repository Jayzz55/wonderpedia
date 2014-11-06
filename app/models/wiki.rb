class Wiki < ActiveRecord::Base
  has_many :users, through: :collaborators
  has_many :collaborators
end
