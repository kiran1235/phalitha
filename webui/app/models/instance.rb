class Instance < ActiveRecord::Base
  has_many :instances_users
  has_many :users, through: :instances_users
  has_many :mappings
  validates :name, presence: true
  validates :description, presence: true
end
