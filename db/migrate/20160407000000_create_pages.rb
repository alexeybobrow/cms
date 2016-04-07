class CreatePages < ActiveRecord::Migration
  def change
    create_table "pages", force: :cascade do |t|
      t.string   "title",          default: "",      null: false
      t.string   "url",            default: "",      null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deleted_at"
      t.string   "name"
      t.string   "workflow_state", default: "draft"
      t.text     "meta"
      t.string   "tags",           default: [],      null: false, array: true
      t.datetime "posted_at",                        null: false
      t.json     "og",             default: [],      null: false
      t.string   "authors",        default: [],      null: false, array: true
      t.integer  "content_id"
      t.integer  "annotation_id"
      t.text     "description"
    end

    add_index "pages", ["authors"], name: "index_pages_on_authors", using: :gin
    add_index "pages", ["tags"], name: "index_pages_on_tags", using: :gin
    add_index "pages", ["url"], name: "index_pages_on_url", using: :btree
  end
end
