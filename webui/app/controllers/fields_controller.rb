require 'securerandom'
class FieldsController < ApplicationController
  layout :resolve_layout
  before_filter :default_format_json, :except=> [:edit, :new, :newuser, :deleteuser]
  helper_method :build_xmlelement_tree
  
  def edit
    @instance=@@user.instances.find(params[:instance_id])
    @mapping = @instance.mappings.find(params[:mapping_id])
    @field=@mapping.mapping_fields.find(params[:id])
    render partial: 'edit'
  end
  
  def update
    @instance=@@user.instances.find(params[:instance_id])
    @mapping = @instance.mappings.find(params[:mapping_id])
    @fields=@mapping.mapping_fields.find(params[:id])
    
    @fields.each do |field|
      i=0
      params[:id].each do |id|
        if field[:id].to_s == id.to_s
          field[:sensitivity] = params[:sensitivity][i]
		  if field[:accesscode].nil?
			field[:accesscode]=SecureRandom.hex(3)
		  end
        end
        i=i+1
      end
    end
    @mapping.mapping_fields << @fields
    @mapping.save
    redirect_to instance_mapping_path(@instance.id,@mapping.id,:s=>3)
  end
  
  def import
    @instance=@@user.instances.find(params[:instance_id])
    @mapping = @instance.mappings.find(params[:mapping_id])
    
    name = params['datafile'].original_filename
    name = Digest::MD5.hexdigest(name)
    directory=Rails.root.join('tmp', 'uploads', name)
    #path=File.join(directory,name)
	path=directory.to_s
    File.open(path, "wb") { |f| f.write(params['datafile'].read) } 
    puts "<ul>"
      build_xml_tree(path)
    puts "</ul>"
    is_xml_errored=false
    begin
      xml_doc=Nokogiri::XML(File.open(path)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
    rescue
      is_xml_errored=true
    end    
    
    if is_xml_errored
      respond_to do |format|
          format.json do
            render :json=> {
              :rc => "1",
              :errors=> xml_doc.errors
              }
          end
        end    
    else
      respond_to do |format|
          format.json do
            render :json=> {
              :rc => "0",
              :redirect=> instance_mapping_fields_new_path(@instance[:id],@mapping[:id],name)
              }
          end
        end    
    end    
    
    return
  end
  
  def new
    @instance=Instance.find_by_id(params[:instance_id])
    @mapping = @instance.mappings.find_by_id(params[:mapping_id])
    @fileid=params[:id]
    #path="tmp/uploads/#{params[:id]}"
	directory=Rails.root.join('tmp', 'uploads', params[:id])
	path=directory.to_path
    @xmltree=build_xml_tree(path)
    @xmltreeform=build_xml_form(path)
    #render partial: 'new'
    #render 'new.html.erb'
  end
  
  def save
    @instance=@@user.instances.find_by_id(params[:instance_id])
    @mapping = @instance.mappings.find_by_id(params[:mapping_id])
	directory=Rails.root.join('tmp', 'uploads', params[:id])
    path=directory.to_path
    @mapping.mapping_fields.each do |m|
      m.destroy 
    end
     
    # @mapping.mapping_fields.each do |m|
      # m.delete
    # end 
      
    @@form_field_names=[]
    get_xml_form_fields(path)
    #p @@form_field_names

    mapping_fields=[]
    
    @@form_field_names.each do |f|
      field=@mapping.mapping_fields.new
      field[:fieldname] = params[f[:fieldname]]
      field[:searchpath] = params[f[:searchpath]]
      field[:rawvalue] = params[f[:rawvalue]]
      field[:sensitivity] = params[f[:sensitivity]]
	  field[:accesscode]=SecureRandom.hex(3)
      if params[f[:isparent]].eql?"1"
        field[:isparent] = 1
      else
        field[:isparent] = 0
      end
      mapping_fields << field
    end
    @mapping.save
    
     mapping_fields.each do |field|
        @@user.permissions << field.permission
     end
    
    #@@user.save
    
    respond_to do |format|
        format.json do
          render :json=> {
            :rc => "0",
            :redirect=> instance_mapping_path(@instance,@mapping,:s=>3)
            }
        end
      end    
    return    
  end
 
 def newuser
   @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
   @field=@mapping.mapping_fields.find(params[:id])
   field_users=[]
   @field.users.each do |u|
     field_users << u[:id]
   end
   @mapping_users=@mapping.users.select('id','name','username').where('id not in (?)',field_users)
   render partial: 'newuser'
 end
  def deleteuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    @field=@mapping.mapping_fields.find(params[:id])
    @mapping_users=@field.users
    @instance=@@user.instances.find(params[:instance_id])
    # @instance_users=@instance.users.select('id','name','username').where('id not in (?)',mapping_users)
    render partial: 'deleteuser'
  end  
 def adduser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    newusers=params[:user_selected].uniq
    @field=@mapping.mapping_fields.find(params[:id])
    exusers=[]
    @field.users.each do |eu|
      exusers << eu[:id]
    end
    new_uniq_users=newusers - exusers
    User.find(new_uniq_users).each do|new_mapping_users|
      new_mapping_users.permissions << @field.permission
    end
    
    respond_to do |format|
        format.json do
          render :json=> {
            :rc => "0"
          }
        end
    end    
    return   
 end
  def removeuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    newusers=params[:user_selected].uniq
    @field=@mapping.mapping_fields.find(params[:id])
    existing_mapping_users=@field.users.where('user_id in (?)',newusers)
    existing_mapping_users.each do |u|
      u.permissions.delete(@field.permission)
    end
    
    #existing_mapping_users.leave_mapping()
    
    respond_to do |format|
        format.json do
          render :json=> {
            :rc => "0"
          }
        end
    end    
    return
  end 
 private 
 
    def get_xml_form_fields(path)
      @i=0
      xml_doc=Nokogiri::XML(File.open(path)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      remove_copies(xml_doc)
      xml_doc.root.element_children.each do |element|
        build_xmlelement_form_fields(element)
      end
    end
    
     def build_xmlelement_form_fields(element)
       @i=@i+1
       field_names={
           :itemnumber=>"itemnumber#{@i}",
           :fieldname=>"fieldname#{@i}",
           :searchpath=>"searchpath#{@i}",
           :rawvalue=>"rawvalue#{@i}",
           :sensitivity=>"#{element.node_name}#{@i}Sensitivity",
           :isparent => "#{element.node_name}#{@i}isparent"
         }
       @@form_field_names << field_names
       
       
        element.element_children.each do |child|
            build_xmlelement_form_fields(child)
        end
    end    
 
    def build_xml_tree(path)
      @i=0
      xml_doc=Nokogiri::XML(File.open(path)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      remove_copies(xml_doc)
      
      str="<ul class='tree'>"
      xml_doc.root.element_children.each do |element|
        str=str+build_xmlelement_tree(element)
      end    
      str=str+"</ul>"
      return str.html_safe
    end
    
    def build_xml_form(path)
      @i=0
      xml_doc=Nokogiri::XML(File.open(path)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      remove_copies(xml_doc)
      
      str=""
      xml_doc.root.element_children.each do |element|
        str=str+build_xmlelement_form(element)
      end    
      return str.html_safe
    end    

    # t.integer "mapping_id"
    # t.string  "fieldname"
    # t.string  "datatype"
    # t.text    "searchpath"
    # t.text    "sensitivity"
    # t.text    "rawvalue"
    # t.boolean "isparent"
    # t.text    "parentkey"
  
     def build_xmlelement_tree(element)
       @i=@i+1
       str=""
       xpath=Nokogiri::CSS.xpath_for element.css_path
       if !element.blank? && !element.text?
         str=str+"<li class='node' xpath='#{xpath.first}' level='#{element.element_children.length}'><span class='minus' data-target='##{element.node_name}#{@i}'>#{element.node_name}</span>"
         is_ol_opened=false
        element.element_children.each do |child|
          if child.blank? || child.text? || child.element_children.length <1
            if !is_ol_opened
              str=str+ "<ol>"
              is_ol_opened=true
            end
            xpath=Nokogiri::CSS.xpath_for element.css_path
            @i=@i+1
            str=str+ "<li class='node' xpath='#{xpath.first}' level='#{child.element_children.length}' value='#{child.text}'><span class='bullet' data-target='##{child.node_name}#{@i}'>#{child.node_name}</span></li>"
            
          else
            str=str+ "<ul>" + build_xmlelement_tree(child)+ "</ul>"
          end
         end
          if is_ol_opened
            str=str+ "</ol>"
          end
          str=str+"</li>"
      else
        str=str+ "<li class='node' xpath='#{xpath.first}' level='#{element.element_children.length}'><span class='minus'>#{element.node_name}</span></li>"
      end
      return str
    end
    
     def build_xmlelement_form(element)
       xpath=Nokogiri::CSS.xpath_for element.css_path
       @i=@i+1
       str="<div id='#{element.node_name}#{@i}' class='hide'>"
       str=str+"<input type='hidden' name='itemnumber#{@i}' value='#{@i}'>"
       str=str+"<input type='hidden' name='fieldname#{@i}' value='#{element.node_name}'>"
       str=str+"<input type='hidden' name='searchpath#{@i}' value='#{xpath.first}'>"
        
       str=str+"<div class='form-group'><div class='col-sm-3'><label class='control-label'>Element</label></div><div class='col-sm-7'><label class='control-label'>#{element.node_name}</label></div></div>"
       str=str+"<div class='form-group'><div class='col-sm-3'><label class='control-label'>XPath</label></div><div class='col-sm-7'><label class='control-label'>#{xpath.first}</label></div></div>"

       if element.text? || element.element_children.length <1
          str=str+"<input type='hidden' name='rawvalue#{@i}' value='#{element.text}'>"
          str=str+"<input type='hidden' name='#{element.node_name}#{@i}isparent' value='0'>"
          str=str+"<div class='form-group'><div class='col-sm-3'><label class='control-label'>Value</label></div><div class='col-sm-7'><label class='control-label'>#{element.text}</label></div></div>"
          str=str+"<div class='form-group'><div class='col-sm-3'><label class='control-label'>Senstivity</label></div><div class='col-sm-7'>"
          str=str+"<div class='radio'><label><input type='radio' name='#{element.node_name}#{@i}Sensitivity' value='0' class='control-label' checked>No </label></div>"
          str=str+"<div class='radio'><label><input type='radio' name='#{element.node_name}#{@i}Sensitivity' value='1' class='control-label'>Yes</label></div>"
          str=str+"</div></div>"
       else
         str=str+"<input type='hidden' name='rawvalue#{@i}' value=''>"
         str=str+"<input type='hidden' name='#{element.node_name}#{@i}Sensitivity' value='0'>"
         str=str+"<input type='hidden' name='#{element.node_name}#{@i}isparent' value='1'>"

       end
        str=str+"</div>"
        element.element_children.each do |child|
            str=str + build_xmlelement_form(child)
       end
      return str
    end
  
  # recursively check if 2 nodes are the same
  def same_nodes?(node1,node2,truth_array=[])
    if node1.nil? || node2.nil?
      return false
    end
    if node1.name != node2.name
      return false
    end
          if node1.text != node2.text
                  return false
          end
    node1_attrs = node1.attributes
    node2_attrs = node2.attributes
    truth_array << same_attributes?(node1_attrs,node2_attrs)
    node1_kids = node1.children
    node2_kids = node2.children
    node1_kids.zip(node2_kids).each do |pair|
      truth_array << same_nodes?(pair[0],pair[1])
    end
    # if every value in the array is true, then the nodes are equal
    return truth_array.all?
  end
  
  # check and see if the attributes are the same
# probably could be done shorter
def same_attributes?(attr1,attr2)
  attr1.each do |k,v|
    if attr2.has_key?(k)
      a1v = v.value
      a2v = attr2[k].value
      if a1v != a2v
        return false
      end
    else
      return false
    end
  end
  # do it the other way so no key is left out
  attr2.each do |k,v|
    if !attr1.has_key?(k)
      return false
    end
  end
  return true
end
  
  
  
  
    # removes duplicate nodes recursively from a document
    def remove_copies(node)
      node_names = node.children.select {|kid| kid.name != "text" }.collect {|k| k.name}
      node_names.uniq!
      node_names.each {|name| remove_duplicates(node,name)}
      node.children.each {|k| remove_copies(k)}
    end
    
    # remove named child duplicates from a node
    def remove_duplicates(node,child_name)
      ex_childs = node.children.select {|kid| kid.name == child_name}
      node.children.each {|k| k.remove if k.name == child_name}
      added_nodes = []
      ex_childs.each do |ec|
        add_me = true
        added_nodes.each do |added_node|
          if same_nodes?(added_node,ec)
            add_me = false
          end
        end
        if add_me
          node.add_child(ec)
          added_nodes << ec
        end
      end
    end
    
  private
    def resolve_layout
        "iframe"
    end
    def default_format_json
      if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
        request.format = "json"
      end
    end    
          
end