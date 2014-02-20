require 'spec_helper'

describe LazyCrawler::Robots do
  before do
    stub_request(:get, "http://localhost/robots.txt").to_return(:body => fixture("robots.txt"))
    stub_request(:get, "http://localhost2/robots.txt").to_return(:status => 404)
    stub_request(:get, "http://localhost/test.html").to_return(:body => "")
    stub_request(:get, "http://localhost/sample.html").to_return(:body => "")
  end

  describe "#allowed?" do
    context "when found robots.txt on server" do
      it "returns true if target url is allowed" do
        expect(LazyCrawler::Robots.allowed?("http://localhost/test.html")).to be_true
      end

      it "returns false if target url is not allowed" do
        expect(LazyCrawler::Robots.allowed?("http://localhost/sample.html")).to be_false
      end
    end
    
    context "when not found robots.txt on server" do
      it "returns true" do
        expect(LazyCrawler::Robots.allowed?("http://localhost2/sample.html")).to be_true
      end
    end
  end
end

