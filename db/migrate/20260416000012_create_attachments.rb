class CreateAttachments < ActiveRecord::Migration[8.1]
  def change
    create_table :attachments, id: :uuid do |t|
      t.uuid    :message_id,       null: false
      t.string  :file_url,         null: false
      t.string  :file_name
      t.string  :content_type
      t.bigint  :file_size                       # bytes
      # attachment_type: 0:image 1:video 2:audio 3:document 4:sticker
      t.integer :attachment_type,  default: 0
      t.integer :width                           # px (images / videos)
      t.integer :height                          # px
      t.integer :duration_seconds                # audio / video
      t.string  :thumbnail_url                   # video poster frame

      t.timestamps
    end

    add_index :attachments, :message_id
  end
end
