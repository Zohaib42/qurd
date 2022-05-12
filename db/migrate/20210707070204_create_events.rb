class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.text :price
      t.text :location
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
