class MappingField < ActiveRecord::Base
  belongs_to :mapping
  has_one :instance, through: :mapping
  has_one :permission
  has_many :userpermissions, through: :permission
  has_many :users, through: :userpermissions
  
  after_create :create_field_permission
  before_destroy :remove_field_permission
  
  def sensitivity_values 
    return [
    "No",
    "Yes"
    ]
  end
  
  def sensitivity_text
    return self.sensitivity_values[self.sensitivity.to_i]
  end
  
  def create_field_permission
    field_permission=Permission.new
    field_permission[:mapping_id]=self.mapping.id
    field_permission[:instance_id]=self.instance.id
    field_permission[:name]="#{self.instance[:name]} #{self.mapping[:name]} #{self[:fieldname]} persmissions"
    field_permission[:mapping_field_id]=self.id
    field_permission.save
  end
  
  def remove_field_permission
    self.permission.destroy
  end
  
end
