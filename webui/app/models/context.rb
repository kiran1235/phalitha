require 'securerandom'
class Context < ActiveRecord::Base
  validates :accesskey, presence: true, uniqueness: true
  belongs_to :instance
  has_many :contexttokens
  before_create :setup_context
  def setup_context
	self.rawdata=SecureRandom.hex(64)
	self.hashkey=SecureRandom.hex(32)
  end
end
