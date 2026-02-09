unless ENV['SKIP_DISCORD_BOT'] == 'true'
  # Setup still calls off to Discord and requires tokens etc. Sometimes (e.g. Docker build process)
  # we don't want that at all, so just skip it.
  Discord::Bot.setup
end

if ENV['RUN_DISCORD_BOT'] == 'true'
  Discord::Bot.run(true)
end
