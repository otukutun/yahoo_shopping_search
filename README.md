# YahooShoppingSearch

[![Build Status](https://travis-ci.com/otukutun/yahoo_shopping_search.svg?branch=main)](https://travis-ci.com/otukutun/yahoo_shopping_search)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/yahoo_shopping_search`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yahoo_shopping_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yahoo_shopping_search

## Usage

### Preparation

Before using this, Please get api key from [this](https://developer.yahoo.co.jp/start/).

### API Detail

If You want to know API detail, Please read [this](https://developer.yahoo.co.jp/webapi/shopping/shopping/v3/itemsearch.html).

### Initialize app id and affiliate id

You can initialize app id and affiliate id like a below code.

```ruby
YahooShoppingSearch.configure do |config|
  config.app_id = 'YOUR APP ID' # required
  config.affiliate_type = 'YOUR AFFILIATE TYPE' # optional
  config.sid = 'YOUR AFFILIATE SID' # optional
  config.pid = 'YOUR AFFILIATE PID' # optional
end
```

### Search Shopping Item

```ruby
result = YahooShoppingSearch::Clients::Item.search(query: 'よなよなエール')
# Fetch data
result.each { |item| p item }
# if you want to go to next page
result.next_page!
# if next_page doesn't exist, NextPageNotFound  Exception is raised.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yahoo_shopping_search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YahooShoppingSearch project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yahoo_shopping_search/blob/master/CODE_OF_CONDUCT.md).
