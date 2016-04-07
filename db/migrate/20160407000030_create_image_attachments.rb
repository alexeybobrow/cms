class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table "image_attachments", force: :cascade do |t|
      t.string   "image"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "deleted",    default: false
    end
  end
end
