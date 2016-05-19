class AddUrls < ActiveRecord::Migration
  def up
    create_table "urls", force: :cascade do |t|
      t.integer  "page_id"
      t.boolean "primary", null: false, default: false
      t.string "name", null: false
      t.timestamps
    end

    add_index :urls, [:page_id, :name], name: "index_urls_on_page_and_name", unique: true

    execute <<-sql
      INSERT INTO urls("page_id", "name", "primary", "created_at", "updated_at")
      SELECT p.id, p.url, TRUE, NOW(), NOW()
      FROM pages p
    sql

    remove_column :pages, :url
  end

  def down
    add_column :pages, :url, :string, default: '', null: false

    execute <<-sql
      UPDATE pages
      SET url = u.name
      FROM (
        SELECT u.name, u.page_id FROM pages p
        JOIN urls u ON u.page_id = p.id AND u.primary = true
      ) u
      WHERE id = u.page_id
    sql

    remove_index :urls, name: "index_urls_on_page_and_name"
    drop_table "urls"
  end
end
