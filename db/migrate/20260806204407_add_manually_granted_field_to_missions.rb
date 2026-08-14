class AddManuallyGrantedFieldToMissions < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :manually_granted, :boolean, default: false
  end
end
