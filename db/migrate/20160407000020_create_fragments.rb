class CreateFragments < ActiveRecord::Migration
  def change
    create_table "fragments", force: :cascade do |t|
      t.string   "slug",       null: false
      t.integer  "content_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "fragments", ["slug"], name: "index_fragments_on_slug", unique: true, using: :btree
  end
end
