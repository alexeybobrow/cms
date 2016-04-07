class CreateLiquidVariables < ActiveRecord::Migration
  def change
    create_table "liquid_variables", force: :cascade do |t|
      t.text     "name",                    null: false
      t.text     "value",      default: ""
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end
  end
end
