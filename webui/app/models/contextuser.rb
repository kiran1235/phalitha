class Contextuser < ActiveRecord::Base
  belongs_to :context
  belongs_to :user
end
