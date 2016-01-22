class MappingsUser < ActiveRecord::Base
  belongs_to :mapping
  belongs_to :user
end
