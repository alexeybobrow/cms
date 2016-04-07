class CreateContents < ActiveRecord::Migration
  def change
    create_table "contents", force: :cascade do |t|
      t.text     "body"
      t.string   "attachments_cache", default: ""
      t.string   "markup_language",   default: "markdown"
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
    end
  end
end
