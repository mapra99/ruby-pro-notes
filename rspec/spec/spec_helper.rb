# frozen_string_literal: true

RSpec.configure do |config|
  config.warnings = true

  config.before(:example, acceptance: true) do
    dir = "#{Dir.tmpdir}/highcard_test_state"
    `rm -Rf #{dir}`
    `mkdir -p #{dir}`
    ENV['HIGHCARD_DIR'] = dir
  end
end
