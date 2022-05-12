class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.belongs_to :member, null: false
      t.belongs_to :post, null: false

      t.timestamps
    end
  end
end
