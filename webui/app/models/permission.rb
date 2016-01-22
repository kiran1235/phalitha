class Permission < ActiveRecord::Base
   belongs_to :instance
   belongs_to :mapping
   belongs_to :mapping_field
   has_many :userpermissions
   has_many :users, through: :userpermission
   
   before_destroy :remove_all_user_permissions
   
   def remove_all_user_permissions
     self.userpermissions.each do |up| up.destroy end
   end
end
