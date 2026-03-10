class Mission
  class StateDefault < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[guild_config_id id name raw_colour]
    end

    def self.ransackable_associations(auth_object = nil)
      ["guild_config"]
    end

    self.table_name = 'mission_state_defaults'

    COLOURS = {
      active: '0x8ff0a4',
      accepted: '0xffbe6f',
      submitted: '0xf9f06b',
      completed: '0x99c1f1',
    }.freeze

    belongs_to :guild_config
    validates :name, inclusion: Mission::STATES, uniqueness: { scope: :guild_config }, presence: true
    validates :raw_colour, presence: true, format: { with: /\A0x[\da-f]{6}\z/ }
    after_create :global_defaults

    def global_defaults
      return unless name
      self.raw_colour ||= COLOURS[name.to_sym]
    end

    def colour
      Integer(raw_colour)
    end

    def colour=(new_colour)
      new_colour = "0x#{new_colour.to_s(16)}" if new_colour.is_a?(Integer)

      self.raw_colour = new_colour
    end
  end
end

