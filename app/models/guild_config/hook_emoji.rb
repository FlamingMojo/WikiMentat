class GuildConfig
  class HookEmoji < ApplicationRecord
    self.table_name = 'hook_emojis'

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at discord_uid guild_config_id hook_name id name updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      ['guild_config']
    end

    DEFAULT_HOOK_EMOJIS = [
      { hook_name: 'PageContentSaveComplete', name: 'pencil2' },
      { hook_name: 'PageDeleteComplete', name: 'wastebasket' },
      { hook_name: 'PageUndeleteComplete', name: 'wastebasket' },
      { hook_name: 'ArticleRevisionVisibilitySet', name: 'spy' },
      { hook_name: 'ArticleProtectComplete', name: 'lock' },
      { hook_name: 'PageMoveComplete', name: 'truck' },
      { hook_name: 'LocalUserCreated', name: 'wave' },
      { hook_name: 'BlockIpComplete', name: 'no_entry_sign' },
      { hook_name: 'UnblockUserComplete', name: 'no_entry_sign' },
      { hook_name:  'UserGroupsChanged', name: 'people_holding_hands' },
      { hook_name: 'UploadComplete', name: 'inbox_tray' },
      { hook_name: 'FileDeleteComplete', name: 'wastebasket' },
      { hook_name: 'FileUndeleteComplete', name: 'wastebasket' },
      { hook_name: 'AfterImportPage', name: 'books' },
      { hook_name: 'ArticleMergeComplete', name: 'card_box' },
      { hook_name: 'ApprovedRevsRevisionApproved', name: 'white_check_mark' },
      { hook_name: 'ApprovedRevsRevisionUnapproved', name: 'white_check_mark' },
      { hook_name: 'ApprovedRevsFileRevisionApproved', name: 'white_check_mark' },
      { hook_name: 'ApprovedRevsFileRevisionUnapproved', name: 'white_check_mark' },
      { hook_name: 'RenameUserComplete', name: 'people_holding_hands' },
    ]

    belongs_to :guild_config

    validates :hook_name, presence: true, inclusion: Webhook.hook_types.keys.map(&:to_s), uniqueness: { scope: :guild_config_id }

    def self.setup_default_emojis(config)
      config.hook_emojis.find_or_initialize_by(DEFAULT_HOOK_EMOJIS)
    end

    def tag
      # Add custom emojis (with discord uid) later
      ":#{name}:"
    end
  end
end
