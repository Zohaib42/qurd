class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :status, default: Notification::STATUSES[:unread]
      t.string :title
      t.references :recipient
      t.references :notifier
      t.references :notifiable, polymorphic: true

      t.timestamps
    end
  end
end
