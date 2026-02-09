class ChangeWikisToHaveManyGuilds < ActiveRecord::Migration[8.1]
  def change
    remove_reference :wikis, :guild, index: true
    add_reference :guild_configs, :wiki, index: true
  end
end
