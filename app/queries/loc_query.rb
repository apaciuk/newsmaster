# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'base64'
class LocQuery < Actor
  # Constants
  X_RAPIDAPI_KEY = ENV['X_RAPIDAPI_KEY']
  GEOLOCATION_URL = ENV['GEOLOCATION_URL'] || 'https://ip-geo-location.p.rapidapi.com/ip/check'
  GEOLOCATION_HOST = ENV['GEOLOCATION_HOST'] || 'ip-geo-location.p.rapidapi.com'
  GEOLOCATION_HEADERS = {
    'x-rapidapi-host': GEOLOCATION_HOST,
    'x-rapidapi-key': X_RAPIDAPI_KEY
  }.freeze
  def call
    url = URI('GEOLOCATION_URL') || URI('http://ip-geo-location.p.rapidapi.com/ip/check?format=json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url, GEOLOCATION_HEADERS)
    # request['X-RapidAPI-Host'] = 'GEOLOCATION_HOST'
    # request['X-RapidAPI-Key'] = 'X_RAPIDAPI_KEY'
    response = http.request(request)
    location = JSON.parse(response.read_body, symbolize_names: true)
    render json: location
  end
end
