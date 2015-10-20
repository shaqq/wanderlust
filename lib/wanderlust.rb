require "wanderlust/version"

module Wanderlust
  class << self
    def safe_zone?
      unless %w(test development dev local).include? ENV['RACK_ENV']
        puts <<-EOF

Careful! Since Wanderlust inserts a bunch of timezone data into
your MySQL instance, it should only be used in your local test or
development environments.

        EOF
        return false
      end

      unless defined?(::ActiveRecord)
        puts <<-EOF

Sorry! Wanderlust only works with ActiveRecord at the moment

¯\\_(ツ)_/¯

Submit a PR on Github if you'd like more robust support

        EOF
        return false
      end

      return true
    end
  end
end
