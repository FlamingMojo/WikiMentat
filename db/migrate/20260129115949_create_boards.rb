class CreateBoards < ActiveRecord::Migration[8.1]
  def change
    change_table :guild_configs do |t|
      t.boolean :wiki_user_verification, default: true
    end

    create_table :boards do |t|
      t.belongs_to :guild
      t.belongs_to :message
      t.belongs_to :wiki, null: true
      t.integer :board_type, null: false, default: 0
      t.timestamps
    end

    change_table :wikis do |t|
      t.string :logo_url
    end
  end
end
