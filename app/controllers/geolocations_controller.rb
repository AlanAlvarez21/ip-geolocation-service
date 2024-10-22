class GeolocationsController < ApplicationController
    before_action :set_geolocation, only: [:show, :destroy]
  
    def index
      @geolocations = Geolocation.all
      render json: @geolocations
    end
  
    def create
      begin
        data = GeolocationService.new(geolocation_params[:input]).call

        geolocation_data = {
          input: geolocation_params[:input],
          ip: data['ip'],
          ip_version: data['type'],
          continent_code: data['continent_code'],
          continent_name: data['continent_name'],
          country_code: data['country_code'],
          country_name: data['country_name'],
          region_code: data['region_code'],
          region_name: data['region_name'],
          city: data['city'],
          zip: data['zip'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          msa: data['msa'],
          dma: data['dma'],
          ip_routing_type: data['ip_routing_type'],
          connection_type: data['connection_type'],
          geoname_id: data.dig('location', 'geoname_id'),
          capital: data.dig('location', 'capital'),
          country_flag: data.dig('location', 'country_flag'),
          country_flag_emoji: data.dig('location', 'country_flag_emoji'),
          calling_code: data.dig('location', 'calling_code'),
          is_eu: data.dig('location', 'is_eu')
        }

        @geolocation = Geolocation.create(geolocation_data)

        if @geolocation.save
          render json: @geolocation, status: :created
        else
          render json: @geolocation.errors, status: :unprocessable_entity
        end
      rescue => e
        render json: { error: e.message }, status: :bad_request
      end
    end
  
    def show
      geolocation = Geolocation.find(params[:id])
  
      render json: geolocation

      # render json: geolocation.as_json(only: [
      #   :ip, :type_of_ip, :continent_code, :continent_name, :country_code, 
      #   :country_name, :region_code, :region_name, :city, :zip, :latitude, 
      #   :longitude, :msa, :dma, :ip_routing_type, :connection_type, :geoname_id, 
      #   :capital, :country_flag, :country_flag_emoji, :calling_code, :is_eu
      # ])
    end
  
    def destroy
      @geolocation.destroy
      head :no_content
    end
  
    private
  
    def set_geolocation
      @geolocation = Geolocation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Geolocation not found' }, status: :not_found
    end
  
    def geolocation_params
      params.require(:geolocation).permit(:input)
    end
  end
  