class GeolocationsController < ApplicationController
    before_action :set_geolocation, only: [:show, :destroy]
  
    def index
      @geolocations = Geolocation.all
      render json: @geolocations
    end
  
    def create
      begin
        geolocation_data = GeolocationService.new(geolocation_params[:ip]).call
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
      render json: @geolocation
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
      params.require(:geolocation).permit(:ip)
    end
  end
  