require 'spec_helper'

describe LazyCrawler do
  before do
    WebMock.reset!
  end

  describe "#configure" do
    {:user_agent => "ua", :timeout => 1, :max_retry => 3}.each do |key, value|
      it "sets the #{key}" do
        LazyCrawler.configure do |config|
          config.send("#{key}=", value)
        end
        expect(LazyCrawler.instance_variable_get(:"@#{key}")).to eq value
      end
    end
  end

  describe "#http_get" do
    before do
      stub_request(:get, "localhost").to_return(:body => "abc", :status => 200)
      stub_request(:get, "localhost/test.html").to_return(:status => 404)
    end

    it "access successful" do
      LazyCrawler.http_get("http://localhost/")
      a_request(:get, "localhost").should have_been_made
    end

    it "returns correct response" do
      res = LazyCrawler.http_get("http://localhost/")
      expect(res.body).to eq("abc")
    end

    it "returns error response" do
      res = LazyCrawler.http_get("http://localhost/test.html")
      expect(res.code).to eq("404")
    end

    it "a address not exists or timeout" do
      stub_request(:get, "http://localhost2/").to_raise("unknown host")
      res = LazyCrawler.http_get("http://localhost2/")
      expect(res).to eq("unknown host")
    end
  end
end
