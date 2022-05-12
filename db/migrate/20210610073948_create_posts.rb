class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :post_type
      t.text :description
      t.integer :creator_id

      t.timestamps
    end
    add_index :posts, :creator_id
  end
end
