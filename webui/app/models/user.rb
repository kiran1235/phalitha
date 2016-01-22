class User < ActiveRecord::Base
  has_many :instances_users
  has_many :instances, through: :instances_users
  
  has_many :mappings_users
  has_many :mappings, through: :mappings_users
  has_many :userpermissions
  has_many :permissions, through: :userpermissions
  has_many :usertokens
  
  has_many :mapping_fields, through: :permissions
  
  before_create :setup_user
  def self.generate_hashkey(username,password)
    return Digest::MD5.hexdigest("#{username}:#{password}")
  end
  def setup_user
    #self.hashkey=Digest::MD5.hexdigest(self.username,self.hashkey)
    self.islocked=0
    self.isdeleted=0
    self.islogged=0
    self.isexpired=0
  end
end
