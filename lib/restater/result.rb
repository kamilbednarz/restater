# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'geocoder'

module Restater
  class Result
    attr_accessor :title, :price, :size, :address, :coordinates

    def initialize page
      @page = page
      self.parse
    end

    def self.from_url url
      page = Nokogiri::HTML(open(url))
      Restater::Result.new(page)
    end

    def is_valid?
      self.price > 0 && self.size > 0 && self.price_per_square_meter > 2000 &&
        self.price_per_square_meter < 25000 && self.address != nil && self.coordinates != nil &&
        self.coordinates != [50.06465009999999, 19.9449799]

    end

    def price_per_square_meter
      self.price / self.size if self.size > 0
    end

    def parse
      self.title = parse_title
      self.price = parse_price
      self.size = parse_size
      self.address = parse_address
      self.coordinates = get_coordinates
    end

    private

    def parse_title
      @page.css('h1').text.strip
    end

    def parse_price
      @page.css('#attributeTable td[style="font-weight:bold"]').text.strip.gsub(/[^0-9,]/,'').to_i
    end

    def parse_size
      get_cell('Wielkość (m2)').text.to_f rescue 0
    end

    def parse_address
      (get_cell('Adres').text rescue "").strip.gsub(/\r\n.*/, '').split(',').delete_if { |a| a == 'Kraków' || a == 'Polska' }.first
    end

    def get_cell title
      cell = @page.css('#attributeTable td.first_col').find do |td|
        td.text.strip == title
      end
      cell.next_sibling.next_sibling if cell
    end

    def get_coordinates
      Geocoder.coordinates("#{self.address}, Kraków, Polska") if self.address
    end
  end
end
