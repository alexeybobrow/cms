class CreateRates < ActiveRecord::Migration
  def change
    create_table "rates", force: :cascade do |t|
      t.integer  "page_id", null: false
      t.integer  "value",   null: false
    end

    add_foreign_key :rates, :pages
  end
end
