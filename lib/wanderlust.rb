require "wanderlust/version"

module Wanderlust
  class << self

    def lacking_mysql_timezone_support?
      # No "true" way to determine this, so let's check for at least
      # 100 time zones in MySQL. Open to suggestions!
      @conn.execute("select count(*) from mysql.time_zone").first.first < 100
    end

    def get_mysql_connection!
      begin
        @conn = ::ActiveRecord::Base.connection
      rescue ::ActiveRecord::ConnectionNotEstablished => e
        puts <<-EOF

Wanderlust will borrow an existing ActiveRecord connection as opposed to creating
and managing a new one. Please make sure that `Wanderlust.ensure_timezones` is called after
`ActiveRecord::Base.establish_connection`

        EOF
        raise e
      end
    end

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
