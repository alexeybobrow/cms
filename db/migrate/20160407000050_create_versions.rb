class CreateVersions < ActiveRecord::Migration
  def change
    create_table "versions", force: :cascade do |t|
      t.string   "item_type",      null: false
      t.integer  "item_id",        null: false
      t.string   "event",          null: false
      t.string   "whodunnit"
      t.text     "object"
      t.text     "object_changes"
      t.datetime "created_at"
    end
  end
end
