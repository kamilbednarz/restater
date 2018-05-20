# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'geocoder'

module Restater
  class OfferBuilder
    attr_accessor :title, :price, :size, :address, :coordinates

    def initialize(url)
      @url = url
    end

    def build
      @page = Nokogiri::HTML(open(url))
      params = params_from_page
      Restater::Offer.new(params)
    end

    private

    attr_reader :url

    def params_from_page
      {
        title: parse_title,
        price: parse_price,
        size: parse_size,
        address: parse_address,
        coordinates: get_coordinates
      }
    end

    def parse_title
      @page.css('.myAdTitle').text.strip
    end

    def parse_price
      binding.pry
      @page.css('.vip-title .price .value .amount').text.strip.gsub(/[^0-9]/,'').to_i
    end

    def parse_size
      get_cell('Wielkość (m2)').text.to_f rescue 0
    end

    def parse_address
      @page.css('.full-address .address').text
      # (get_cell('Adres').text rescue "").strip.gsub(/\r\n.*/, '').split(',').delete_if { |a| a == 'Kraków' || a == 'Polska' }.first
    end

    def get_cell title
      cell = @page.css('.attribute span.name').find do |td|
        td.text.strip == title
      end
      cell.next_sibling.next_sibling if cell
    end

    def get_coordinates
      @page.css('.google-maps-link')
        .attribute('data-uri')
        .value
        .split('q=')
        .last
        .split(',')
        .map(&:to_f)
    end
  end
end
