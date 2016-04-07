class CreateUsers < ActiveRecord::Migration
  def change
    create_table "users", force: :cascade do |t|
      t.string   "username",   default: "",    null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_admin",   default: false
      t.boolean  "is_locked",  default: false
      t.datetime "deleted_at"
      t.string   "name"
    end

    add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  end
end
