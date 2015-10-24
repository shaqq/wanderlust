require "wanderlust/version"

module Wanderlust
  class << self
    def ensure_timezones
      return unless safe_zone?

      get_mysql_connection!

      import_timezones! if lacking_mysql_timezone_support?
    end

    def cleanup
      return unless safe_zone?

      get_mysql_connection!

      delete_timezones!
    end

    def import_timezones!
      sql_file_location = "#{File.dirname(__FILE__)}/wanderlust/import_timezones.sql"
      sql = File.read(sql_file_location)
      statements = sql.split(';')
      statements.pop # empty line at the end

      ::ActiveRecord::Base.transaction do
        statements.each do |statement|
          @conn.execute(statement)
        end
      end
    end

    def delete_timezones!
      sql_file_location = "#{File.dirname(__FILE__)}/wanderlust/delete_timezones.sql"
      sql = File.read(sql_file_location)
      statements = sql.split(';')
      statements.pop # empty line at the end

      ::ActiveRecord::Base.transaction do
        statements.each do |statement|
          @conn.execute(statement)
        end
      end
    end

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
and managing a new one. Please make sure that `ActiveRecord::Base.establish_connection`
is called before using Wanderlust

        EOF
        raise e
      end
    end

    def safe_zone?
      unless %w(test development dev local).include? ENV['RACK_ENV']
        puts <<-EOF

Careful! Since Wanderlust inserts a bunch of timezone data into your MySQL instance,
it should only be used in your local test or development environments.

        EOF
        raise StandardError, "Not in a `test`, `development`, `dev`, or `local` environment"
      end

      unless defined?(::ActiveRecord)
        puts <<-EOF

Sorry! Wanderlust only works with ActiveRecord at the moment

¯\\_(ツ)_/¯

Submit a PR on Github if you'd like more robust support

        EOF
        raise NameError, "ActiveRecord not defined"
      end

      return true
    end
  end
end
