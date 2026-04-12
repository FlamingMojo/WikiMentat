class AddBulkUploads < ActiveRecord::Migration[8.1]
  def change
    change_table :guild_configs do |t|
      t.boolean :bulk_uploads, null: false, default: false
    end

    rename_column :guild_configs, :enable_image_upload, :discord_image_upload
  end
end
