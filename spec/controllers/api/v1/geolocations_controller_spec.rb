require 'rails_helper'

RSpec.describe Api::V1::GeolocationsController, type: :controller do
  let(:valid_attributes) do
    {
      input: 'https://positrace.com/en/'
    }
  end

  let(:invalid_attributes) do
    {
      input: ''
    }
  end

  let(:mock_response) do
    {
      "input" => "https://positrace.com/en/",
      "ip" => "172.66.42.246",
      "ip_version" => "ipv4",
      "continent_code" => "NA",
      "continent_name" => "North America",
      "country_code" => "US",
      "country_name" => "United States",
      "region_code" => "CA",
      "region_name" => "California",
      "city" => "San Francisco",
      "zip" => "94107",
      "latitude" => 37.76784896850586,
      "longitude" => -122.3928604125976,
      "msa" => "41860",
      "dma" => "807",
      "ip_routing_type" => "fixed",
      "connection_type" => "tx"
    }
  end

  before do
    allow(GeolocationService).to receive(:new).and_return(instance_double(GeolocationService, call: mock_response))
  end

  describe "GET #index" do
    it "returns a success response" do
      geolocation = Geolocation.create!(mock_response)
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).first["ip"]).to eq("172.66.42.246")
    end
  end

  describe "GET #show" do
    context "when the geolocation exists" do
      it "returns the geolocation" do
        geolocation = Geolocation.create!(mock_response)
        get :show, params: { id: geolocation.id }
        expect(response).to be_successful
        expect(JSON.parse(response.body)["ip"]).to eq(geolocation.ip)
      end
    end

    context "when the geolocation does not exist" do
      it "returns a not found response" do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Geolocation not found")
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new geolocation" do
        expect {
          post :create, params: { geolocation: valid_attributes }
        }.to change(Geolocation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["ip"]).to eq("172.66.42.246")
      end
    end

    context "with invalid attributes" do
      it "does not create a new geolocation" do
        expect {
          post :create, params: { geolocation: invalid_attributes }
        }.to_not change(Geolocation, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the geolocation exists" do
      it "destroys the geolocation" do
        geolocation = Geolocation.create!(mock_response)
        expect {
          delete :destroy, params: { id: geolocation.id }
        }.to change(Geolocation, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the geolocation does not exist" do
      it "returns a not found response" do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Geolocation not found")
      end
    end
  end
end
