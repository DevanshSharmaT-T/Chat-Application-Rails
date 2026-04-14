class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups, id: :uuid do |t|
       t.string :name, null: false
       t.text :description
       t.references :user, null: false, foreign_key: true, type: :uuid
       t.datetime :deleted_at, index: true
  
       t.timestamps
     end
  end
end
