require 'rails_helper'

RSpec.describe InputExtractorService do
  describe "#call" do
    context "with a valid URL" do
      let(:service) { InputExtractorService.new("http://example.com") }

      it "extracts the IP from the URL and returns it along with the URL" do
        ip, url = service.call

        expect(url).to eq("http://example.com")
        expect(ip).to be_present
      end
    end

    context "with a valid IP address" do
      let(:service) { InputExtractorService.new("192.168.1.1") }

      it "returns the IP address and nil for URL" do
        ip, url = service.call

        expect(url).to be_nil
        expect(ip).to eq("192.168.1.1")
      end
    end

    context "with an invalid URL" do
      let(:service) { InputExtractorService.new("invalid_url") }

      it "raises an error" do
        expect { service.call }.to raise_error(InputExtractorService::InvalidInputError, "Invalid IP or URL provided")
      end
    end

    context "with an invalid IP address" do
      let(:service) { InputExtractorService.new("999.999.999.999") }

      it "raises an error" do
        expect { service.call }.to raise_error(InputExtractorService::InvalidInputError, "Invalid IP or URL provided")
      end
    end

    context "with an empty input" do
      let(:service) { InputExtractorService.new("") }

      it "raises an error" do
        expect { service.call }.to raise_error(InputExtractorService::InvalidInputError, "Invalid IP or URL provided")
      end
    end

    context "with a non-resolvable URL" do
      let(:service) { InputExtractorService.new("http://nonexistent.domain") }

      it "raises an error when trying to resolve IP" do
        expect { service.call }.to raise_error(InputExtractorService::InvalidInputError, "Invalid IP or URL provided")
      end
    end
  end
end
