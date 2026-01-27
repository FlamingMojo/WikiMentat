module DiscordID
  # Generates a random discord ID (integer between 17 and 19 digits long)
  def self.random
    SecureRandom.random_number(10**16...10**19).to_s
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
