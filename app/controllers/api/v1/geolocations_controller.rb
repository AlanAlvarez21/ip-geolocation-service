module Api
  module V1
    class GeolocationsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: :create
      before_action :set_geolocation, only: [ :show, :destroy ]

      def index
        @geolocations = Geolocation.all
        render json: @geolocations
      end

      def create
        input = geolocation_params[:input]

        # Manejar el caso donde no se proporciona input
        if input.blank?
          render json: { error: "Invalid IP or URL" }, status: :unprocessable_entity and return
        end

        input_extractor = InputExtractorService.new(input)
        extracted_ip, url = input_extractor.call

        # Verifica que se haya extraído al menos un valor válido
        if extracted_ip.blank? && url.blank?
          render json: { error: "Invalid IP or URL" }, status: :unprocessable_entity and return
        end

        # Llamada al servicio para obtener datos de geolocalización
        data = GeolocationService.new(extracted_ip).call

        geolocation_data = {
          input: extracted_ip || url,
          url: url.presence,
          ip: data["ip"],
          ip_version: data["ip_version"],
          continent_code: data["continent_code"],
          continent_name: data["continent_name"],
          country_code: data["country_code"],
          country_name: data["country_name"],
          region_code: data["region_code"],
          region_name: data["region_name"],
          city: data["city"],
          zip: data["zip"],
          latitude: data["latitude"],
          longitude: data["longitude"],
          msa: data["msa"],
          dma: data["dma"],
          ip_routing_type: data["ip_routing_type"],
          connection_type: data["connection_type"],
          geoname_id: data.dig("location", "geoname_id"),
          capital: data.dig("location", "capital"),
          country_flag: data.dig("location", "country_flag"),
          country_flag_emoji: data.dig("location", "country_flag_emoji"),
          calling_code: data.dig("location", "calling_code"),
          is_eu: data.dig("location", "is_eu")
        }

        @geolocation = Geolocation.new(geolocation_data) # Crear un nuevo objeto Geolocation

        if @geolocation.save # Guardar en lugar de actualizar
          render json: @geolocation, status: :created
        else
          render json: { errors: @geolocation.errors }, status: :unprocessable_entity
        end
      end


      def show
        render json: @geolocation.as_json
      end

      def destroy
        @geolocation = Geolocation.find_by(id: params[:id])

        if @geolocation
          @geolocation.destroy
          head :no_content
        else
          render json: { error: "Geolocation not found" }, status: :not_found
        end
      end

      private

      def set_geolocation
        @geolocation = Geolocation.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Geolocation not found" }, status: :not_found
      end

      def find_existing_geolocation(extracted_ip, url)
        Geolocation.find_by("url = ? OR ip = ?", url, extracted_ip)
      end

      def geolocation_params
        params.require(:geolocation).permit(:input)
      end
    end
  end
end
