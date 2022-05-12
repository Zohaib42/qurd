class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :member, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
