# LazyCrawler

A simple web crawler.

## Installation

Add this line to your application's Gemfile:

    gem 'lazy_crawler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_crawler

## Usage

Get HTML file from url

```ruby
html = LazyCrawler.http_get("http://example.com/")
```

Check allowed crawler to web site from robots.txt and meta tag

```ruby
url = "http://example.com/"

if LazyCrawler::Robots.allowed?(url)
  http = LazyCrawler.http_get(url)
end
```

If you want to setup configuration

```ruby
LazyCrawler.configure do |config|
  config.user_agent = 'Your Crawler Agent Here'
  config.timeout = 300  # set request timeout
  config.max_retry = 3  # set max retry count to continue request
end
```

## Contributing

1. Fork it ( http://github.com/stbmp23/lazy_crawler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
