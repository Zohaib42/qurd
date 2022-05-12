class CreateCommentTags < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_tags do |t|
      t.references :comment
      t.references :member

      t.timestamps
    end
  end
end
