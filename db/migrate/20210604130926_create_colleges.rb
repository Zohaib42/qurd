class CreateColleges < ActiveRecord::Migration[6.1]
  def change
    create_table :colleges do |t|
      t.string :name, limit: 255, null: false
      t.decimal :lat
      t.decimal :lng

      t.timestamps
    end
  end
end
