# frozen_string_literal: true

module Discord::Commands
  module Missions
    extend ::Discord::CommandHandler
    include ::Translatable

    with_locale_context 'discord.commands.missions.tooltip'

    class << self
      def setup
        register_commands
        register_handlers
      end

      def register_commands
        Discord.slash_command(:post_mission, t('post'))
        Discord.slash_command(:abandon_mission, t('abandon'))
        Discord.slash_command(:cancel_mission, t('cancel')) do |cmd|
          cmd.string('id', t('fields.id'), required: true)
        end
        Discord.slash_command(:missions, t('count')) do |cmd|
          cmd.user('target_user', 'Other discord user', required: false)
        end
        Discord.slash_command(:manual_reward, t('manually_reward')) do |cmd|
          cmd.user('target_user', 'Discord user', required: true)
        end
        Discord.slash_command(:rewards, t('rewards'))
      end

      def register_handlers
        handle_command(:post_mission, 'Discord::Commands::Missions::Init')
        handle_select_menu('mission:new', 'Discord::Commands::Missions::New')
        handle_modal(/^mission:create:/, 'Discord::Commands::Missions::Create')
        handle_button(/^mission:accept:/, 'Discord::Commands::Missions::Accept')
        handle_button(/^mission:abandon:/, 'Discord::Commands::Missions::Abandon')
        handle_button(/^mission:approve:/, 'Discord::Commands::Missions::Approve')
        handle_button(/^mission:reject:/, 'Discord::Commands::Missions::Reject')
        handle_button(/^mission:image:confirm:/, 'Discord::Commands::Missions::Submit::UploadImage::Confirm')
        handle_button(/^mission:image:cancel:/, 'Discord::Commands::Missions::Submit::UploadImage::Cancel')
        handle_button(/^mission:reward:confirm:/, 'Discord::Commands::Missions::Reward::Confirm')

        handle_command(:abandon_mission, 'Discord::Commands::Missions::AbandonCommand')
        handle_command(:cancel_mission, 'Discord::Commands::Missions::Cancel')
        handle_command(:missions, 'Discord::Commands::Missions::Count')
        handle_command(:mission, 'Discord::Commands::Missions::Find')
        handle_command(:rewards, 'Discord::Commands::Missions::Rewards')
        handle_command(:manual_reward, 'Discord::Commands::Missions::ManuallyReward')
      end
    end
  end
end


