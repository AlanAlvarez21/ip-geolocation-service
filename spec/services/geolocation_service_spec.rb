require 'rails_helper'

RSpec.describe GeolocationService, type: :service do
  let(:valid_ip) { "172.66.42.246" }
  let(:valid_url) { "https://positrace.com/en/" }
  let(:invalid_ip) { "999.999.999.999" }
  let(:invalid_url) { "https://invalid-url" }
  let(:api_key) { "846a08a0834371e69dd2bc546df74199" }
  let(:mock_success_response) do
    {
      "ip" => "172.66.42.246",
      "type" => "ipv4",
      "continent_code" => "NA",
      "continent_name" => "North America",
      "country_code" => "US",
      "country_name" => "United States",
      "region_code" => "CA",
      "region_name" => "California",
      "city" => "San Francisco",
      "zip" => "94107",
      "latitude" => "37.76784896850586",
      "longitude" => "-122.3928604125976"
    }
  end

  let(:mock_failure_response) do
    {
      "error" => { "info" => "Invalid IP" }
    }
  end

  describe "#call" do
    context "with a valid IP" do
      it "returns geolocation data" do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: mock_success_response))

        service = GeolocationService.new(valid_ip)
        result = service.call

        expect(result["ip"]).to eq("172.66.42.246")
        expect(result["city"]).to eq("San Francisco")
      end
    end

    context "with a valid URL" do
      it "resolves the IP and returns geolocation data" do
        allow(Resolv).to receive(:getaddress).with(URI.parse(valid_url).host).and_return(valid_ip)
        allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: mock_success_response))

        service = GeolocationService.new(valid_url)
        result = service.call

        expect(result["ip"]).to eq("172.66.42.246")
        expect(result["city"]).to eq("San Francisco")
      end
    end

    context "with an invalid IP" do
      it "raises an error for invalid IP" do
        service = GeolocationService.new(invalid_ip)

        expect { service.call }.to raise_error(StandardError, "Invalid IP or URL")
      end
    end

    context "with an invalid URL" do
      it "raises an error for invalid URL" do
        service = GeolocationService.new(invalid_url)

        expect { service.call }.to raise_error(StandardError, "Invalid IP or URL")
      end
    end

    context "when the API request fails" do
      it "raises an error with a failure message from the API" do
        allow(HTTParty).to receive(:get).and_return(double(success?: false, parsed_response: mock_failure_response))

        service = GeolocationService.new(valid_ip)

        expect { service.call }.to raise_error(StandardError, "Failed to retrieve geolocation data: Invalid IP")
      end
    end
  end
end
