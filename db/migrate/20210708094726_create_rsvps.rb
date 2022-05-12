class CreateRsvps < ActiveRecord::Migration[6.1]
  def change
    create_table :rsvps do |t|
      t.references :member
      t.references :event

      t.timestamps
    end
  end
end
