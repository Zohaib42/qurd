class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.belongs_to :member
      t.string :token
      t.string :platform
      t.timestamps
    end
  end
end
