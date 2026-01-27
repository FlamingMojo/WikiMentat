Discord::Bot.setup

if ENV['RUN_DISCORD_BOT'] == 'true'
  Discord::Bot.run
end
