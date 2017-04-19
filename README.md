# PatientlyTry

Just another DSL gem to surround your code with retry blocks. I use it with ActiveSupport
to retry stuff, but you can use it with every piece of code that might, or might not raise
an error that can magically resolve itself.

## Installation

Add this line to your application"s Gemfile:

```ruby
gem "patiently_try"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install patiently_try

## Usage

Without any options:

```ruby
require "net/http"

patiently_try do
  Net::HTTP.get(URI("http://google.com"))
end
```

I would recommend to keep the retried code block as small as possible, to avoid unintentional retries.

You can use the following options:

* `retries: 100` - The number of retries you want to attempt before giving up and reraising the error.
* `wait: 0` - How long you want to wait before retrying (in seconds)
* `catch: [StandardError]` - If you want only specific errors to be caught (value can be an array or a single error).
* `logging: true` - If you do not want any output, set this to false.

```ruby
require "net/http"

patiently_try retries: 2, wait: 1, catch: [Timeout::Error, Errno::ECONNREFUSED] do
  Net::HTTP.get(URI("http://10.0.0.0"))
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ninigi/patiently_try. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To open a pull request:

* Fork it
* Add your code
* Open a PR


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
