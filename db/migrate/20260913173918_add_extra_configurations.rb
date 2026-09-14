class AddExtraConfigurations < ActiveRecord::Migration[8.1]
  def change
    change_table :configured_channels do |t|
      t.integer :channel_mission_type, null: false, default: 0
    end

    remove_column :reward_types, :reward_key, :integer, null: false, default: 0
    remove_column :reward_types, :threshold, :integer, null: false, default: 0
    remove_column :reward_types, :threshold_type, :integer, null: false, default: 0
    add_column :reward_types, :config, :jsonb, null: false, default: '{}'
  end
end
