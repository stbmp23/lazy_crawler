lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_crawler'

url = "http://over-lap.co.jp/Form/Product/BunkoThisMonth.aspx"
res = LazyCrawler.http_get(url)
p res.body
