# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'base64'
class QueryCreator < ApplicationService
  # Constants
  X_RAPIDAPI_KEY = ENV['X_RAPIDAPI_KEY']
  GEOLOCATION_URL = ENV['GEOLOCATION_URL'] || 'https://ip-geo-location.p.rapidapi.com/ip/check'
  GEOLOCATION_HOST = ENV['GEOLOCATION_HOST'] || 'ip-geo-location.p.rapidapi.com'
  WEATHER_URL = ENV['WEATHER_URL'] || 'https://community-open-weather-map.p.rapidapi.com/weather?units=imperial&q='
  WEATHER_HOST = ENV['WEATHER_HOST'] || 'community-open-weather-map.p.rapidapi.com'
  NEWS_URL = ENV['NEWS_URL'] || 'https://latest-breaking-news-live.p.rapidapi.com/latest-breaking-news'
  NEWS_HOST = ENV['NEWS_HOST'] || 'latest-breaking-news-live.p.rapidapi.com'
  attr_reader :step, :query, :location, :weather, :news

  # Arguments
  arg :url, type: URI, required: true, context: true, desc: 'The URL to the query'
  arg :http, type: Method, required: true, context: true, desc: 'The HTTP method to use'
  arg :request, type: Object, required: true, context: true, desc: 'The request object'
  arg :response, type: Object, required: true, context: true, desc: 'The response object'

  # Steps
  step :index
  step :create_clim_query, after: :index, input: :loc_output
  step :create_news_query, after: :create_clim_query, input: :clim_output

  # Outputs
  output :loc_output
  output :clim_output
  output :news_output

  private

  def create_clim_query
    url = URI('WEATHER_URL') || URI('https://community-open-weather-map.p.rapidapi.com/weather?units=imperial&q=')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https' && !http.started?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request['X-RapidAPI-Host'] = 'WEATHER_HOST'
    request['X-RapidAPI-Key'] = 'X_RAPIDAPI_KEY'
    response = http.request(request)
    clim_output = JSON.parse(response.read_body, symbolize_names: true)
    render json: clim_output
    run create_news_query, clim_output:
  end

  def create_news_query
    url = URI('NEWS_URL') || 'https://latest-breaking-news-live.p.rapidapi.com/latest-breaking-news'
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https' && !http.started?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request['X-RapidAPI-Host'] = 'NEWS_HOST'
    request['X-RapidAPI-Key'] = 'X_RAPIDAPI_KEY'
    response = http.request(request)
    news_output = JSON.parse(response.read_body, symbolize_names: true)
    render json: news_output
  end
end
