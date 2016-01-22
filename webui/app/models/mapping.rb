class Mapping < ActiveRecord::Base
  belongs_to :instance
  has_one :property
  has_many :mapping_fields
  has_many :mappings_users
  has_many :users, through: :mappings_users

  validates :name, presence: true
  validates :description, presence: true
  validates :sourcetype, inclusion: { in: %w(xml database), message: "%{value} is not valid" }, presence: true
  validates :sourcefilepath, presence: true, if: :is_xml?
  validates :targetfilepath, presence: true, if: :is_xml?  
  validates :sourcefilename, presence: true, if: :is_xml? 
  validates :databasetype, presence: true, if: :is_database?
  validates :hostname, presence: true, if: :is_database? 
  validates :portno, numericality: { only_integer: true }, presence: true, if: :is_database? 
  validates :databasename, presence: true, if: :is_database? 
  validates :username, presence: true, if: :is_database? 
  validates :accesscode, presence: true, if: :is_database? 
  validates :sourcename, presence: true, if: :is_database? 
  validates :targetname, presence: true, if: :is_database? 
  
  after_create :generate_access_point
   

  def generate_access_point
    self.update_column(:mapping_access_point,self.id.to_s.unpack('H*').join(""))
  end
  
  def valid_source_types
    return ["xml","database"]
  end
    
  def is_xml?
    if !sourcetype.nil? 
      return sourcetype == "xml"
    end
  end
  def is_database?
    if !sourcetype.nil? 
      return sourcetype == "database"
    end
  end
end
