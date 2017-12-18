[![Gem Version](https://badge.fury.io/rb/patiently_try.svg)](https://badge.fury.io/rb/patiently_try)
[![Build Status](https://travis-ci.org/Ninigi/patiently_try.svg?branch=master)](https://travis-ci.org/Ninigi/patiently_try)

# PatientlyTry

Just another DSL gem to surround your code with retry blocks. I use it with ActiveResource
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
include PatientlyTry

patiently_try do
  Net::HTTP.get(URI("http://google.com"))
end
```

I would recommend to keep the retried code block as small as possible, to avoid unintentional retries.

## Options

The following options are available:

* `retries: 100` - The number of retries you want to attempt before giving up and reraising the error.
* `wait: 0` - How long you want to wait between retries (in seconds).
* `catch: [StandardError]` - If you want only specific errors to be caught (value can be an array or a single error).
* `raise_if_caught: []` - If you want to exclude an error from being caught through inheritance.
* `logging: true` - If you do not want any output, set this to false.

```ruby
require "net/http"
include PatientlyTry

patiently_try retries: 2, wait: 1, catch: [Timeout::Error, Errno::ECONNREFUSED] do
  Net::HTTP.get(URI("http://10.0.0.0"))
end
```

The `:catch` and `:raise_if_caught` can be used together to limit the amount of errors that will be retried.
If only `:raise_if_caught` is set, it will retry every `StandardError` except the ones specified.

```ruby
patiently_try raise_if_caught: [ArgumentError] do
  # This will trigger retries, since NoMethodError is a StandardError
  raise NoMethodError

  # This will not trigger a retry and fail on first try
  raise StandardError
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
