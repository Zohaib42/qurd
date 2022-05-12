class CreateSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.string :name, limit: 255, null: false, index: { unique: true }
      t.integer :creatives

      t.timestamps
    end
  end
end
