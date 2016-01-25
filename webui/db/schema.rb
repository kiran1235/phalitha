# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160125025640) do

  create_table "contextpermissions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contexts", force: true do |t|
    t.integer  "instance_id"
    t.text     "rawdata",     limit: 2147483647, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contexts", ["instance_id"], name: "index_contexts_on_instance_id", using: :btree

  create_table "contexttokens", force: true do |t|
    t.integer  "context_id"
    t.string   "context_token"
    t.text     "context_token_data", limit: 2147483647, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contexttokens", ["context_id"], name: "index_contexttokens_on_context_id", using: :btree

  create_table "contextusers", force: true do |t|
    t.integer  "context_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contextusers", ["context_id"], name: "index_contextusers_on_context_id", using: :btree
  add_index "contextusers", ["user_id"], name: "index_contextusers_on_user_id", using: :btree

  create_table "instances", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "createddate"
    t.datetime "modifieddate"
  end

  create_table "instances_users", id: false, force: true do |t|
    t.integer "instance_id"
    t.integer "user_id"
  end

  add_index "instances_users", ["instance_id"], name: "index_instances_users_on_instance_id", using: :btree
  add_index "instances_users", ["user_id"], name: "index_instances_users_on_user_id", using: :btree

  create_table "logs", force: true do |t|
    t.string   "whatid",                          null: false
    t.integer  "whoid",                           null: false
    t.text     "logdata",      limit: 2147483647, null: false
    t.datetime "createddate"
    t.datetime "modifieddate"
  end

  create_table "mapping_fields", force: true do |t|
    t.integer "mapping_id"
    t.string  "fieldname"
    t.string  "datatype"
    t.text    "searchpath"
    t.text    "sensitivity"
    t.text    "rawvalue"
    t.boolean "isparent"
    t.text    "parentkey"
    t.text    "accesscode"
  end

  add_index "mapping_fields", ["mapping_id"], name: "index_mapping_fields_on_mapping_id", using: :btree

  create_table "mapping_source_xml", force: true do |t|
    t.integer "mapping_id"
    t.string  "rawdata"
    t.string  "datatype"
    t.text    "searchpath"
  end

  add_index "mapping_source_xml", ["mapping_id"], name: "index_mapping_source_xml_on_mapping_id", using: :btree

  create_table "mapping_users", id: false, force: true do |t|
    t.integer "mapping_id"
    t.integer "user_id"
  end

  add_index "mapping_users", ["mapping_id"], name: "index_mapping_users_on_mapping_id", using: :btree
  add_index "mapping_users", ["user_id"], name: "index_mapping_users_on_user_id", using: :btree

  create_table "mappings", force: true do |t|
    t.integer  "instance_id"
    t.string   "name"
    t.text     "description"
    t.string   "environment"
    t.string   "sourcetype"
    t.datetime "createddate"
    t.datetime "modifieddate"
    t.text     "sourcefilepath"
    t.text     "targetfilepath"
    t.text     "sourcefilename"
    t.text     "targetfilename"
    t.string   "databasetype"
    t.string   "hostname"
    t.integer  "portno"
    t.string   "encoding"
    t.text     "databasename"
    t.string   "username"
    t.string   "accesscode"
    t.text     "sourcename"
    t.text     "targetname"
    t.text     "mapping_access_point"
    t.integer  "iswatching"
  end

  add_index "mappings", ["instance_id"], name: "index_mappings_on_instance_id", using: :btree

  create_table "mappings_users", id: false, force: true do |t|
    t.integer "mapping_id"
    t.integer "user_id"
  end

  add_index "mappings_users", ["mapping_id"], name: "index_mappings_users_on_mapping_id", using: :btree
  add_index "mappings_users", ["user_id"], name: "index_mappings_users_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "mapping_id"
    t.integer  "instance_id"
    t.string   "name"
    t.boolean  "islocked"
    t.boolean  "isdisabled"
    t.datetime "createddate"
    t.datetime "modifieddate"
    t.integer  "mapping_field_id"
  end

  add_index "permissions", ["instance_id"], name: "index_permissions_on_instance_id", using: :btree
  add_index "permissions", ["mapping_id"], name: "index_permissions_on_mapping_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "userpermissions", force: true do |t|
    t.integer  "permission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "userpermissions", ["permission_id"], name: "index_userpermissions_on_permission_id", using: :btree
  add_index "userpermissions", ["user_id"], name: "index_userpermissions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "username"
    t.string   "hashkey"
    t.boolean  "islocked"
    t.boolean  "isdeleted"
    t.boolean  "islogged"
    t.boolean  "isexpired"
    t.datetime "createddate"
    t.datetime "modifieddate"
  end

  create_table "usertokens", force: true do |t|
    t.integer  "user_id"
    t.string   "data",        null: false
    t.text     "requestdata", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usertokens", ["data"], name: "index_usertokens_on_data", using: :btree
  add_index "usertokens", ["updated_at"], name: "index_usertokens_on_updated_at", using: :btree

end
