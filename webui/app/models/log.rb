class Log < ActiveRecord::Base
  belongs_to :user, foreign_key: "whoid", primary_key: "id"
  belongs_to :instance, foreign_key: "whoid", primary_key: "id"
  belongs_to :mapping, foreign_key: "whoid", primary_key: "id"
  
  #belongs_to :user, -> {where id: :whoid}, foreign_key: "whoid"
  #has_one :users, -> { where { whatid "user" } }, foreign_key: :whoid
  
  #has_many :instances, :conditions => ['whatid =?','instance'], :foreign_key => "whoid"
  #has_many :mappings, :conditions => ['whatid =?','mapping'], :foreign_key => "whoid"
end
