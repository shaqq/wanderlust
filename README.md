# Wanderlust

A convenient way to enable MySQL timezone support for your ActiveRecord specs. It's mainly for your dev and CI environments, as it will import a set of timezones into your MySQL instance. __This should not be used in Production.__

If you'd like to get MySQL timezone support on your Mac without using Wanderlust, this should do the trick:

```bash
mysql_tzinfo_to_sql /usr/share/zoneinfo | sed -e "s/Local time zone must be set--see zic manual page/local/" | mysql -u root mysql
```

This gem is compatible with at least MySQL 5.6.19.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wanderlust'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wanderlust

## Usage

Here's what the usage would look like in your typical spec_helper:

```ruby
RSpec.configure do |config|

  config.before(:suite) do
    Wanderlust.ensure_timezones
    DatabaseCleaner.strategy = :transaction
    # etc...
  end
end
```

Wanderlust will import timezones into your MySQL instance, so if you'd like to remove them after your specs:

```ruby
  config.after(:suite) do
    Wanderlust.cleanup
  end
```

## Troubleshooting

__I get a huge error full of SQL statements. What do I do?__

In this case, most likely your MySQL instance is in an odd state or somehow your `mysql.time_zone` table got truncated without cascading the deletes. Try restarting your MySQL instance and cleaning up remaining timezones, like so:

```
# /bin/bash or your preferred shell
mysql restart

# in irb/pry
Wanderlust.cleanup
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shaqq/wanderlust. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

