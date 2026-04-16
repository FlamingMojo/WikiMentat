class CreateAPIKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys do |t|
      t.belongs_to :user, null: false, index: { unique: true }
      t.string :key, null: false, index: { unique: true }
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    create_table :api_request_logs do |t|
      t.belongs_to :api_key, null: false, index: true
      t.string :endpoint
      t.jsonb :payload
      t.string :request_method
      t.integer :response_code
      t.jsonb :response_body
      t.timestamps
    end
  end
end
