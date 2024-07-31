class WeatherController < ApplicationController
  require 'httparty'

  def index
    @city = params[:city] || 'Santiago'
    @api_key = '59301dbd56da6e1d408ed4018b667f85' # Reemplaza con tu nueva clave API
    @url = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&appid=#{@api_key}&units=metric"

    begin
      response = HTTParty.get(@url)
      @weather_data = response.parsed_response

      if @weather_data['cod'] == 200
        @temperature = @weather_data['main']['temp']
        @description = @weather_data['weather'][0]['description']
        @icon = @weather_data['weather'][0]['icon']
      else
        @error_message = @weather_data['message'] || "Error al obtener datos del clima."
      end
    rescue SocketError => e
      @error_message = "Error de conexión: #{e.message}. Por favor, verifica tu conexión a internet."
    rescue StandardError => e
      @error_message = "Error inesperado: #{e.message}. Intenta nuevamente más tarde."
    end
  end
end
