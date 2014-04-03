# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

module Restater
  class Result
    attr_accessor :title, :price, :size

    def initialize page
      @page = page
      self.parse
    end

    def parse
      self.title = parse_title
      self.price = parse_price
      self.size = parse_size
    end

    def self.from_url url
      page = Nokogiri::HTML(open(url))
      Restater::Result.new(page)
    end

    private

    def parse_title
      @page.css('h1').text.strip
    end

    def parse_price
      @page.css('#attributeTable td[style="font-weight:bold"]').text.strip.gsub(/[^0-9,]/,'').to_i
    end

    def parse_size
      cell = @page.css('#attributeTable td.first_col').find do |td|
        td.text.strip == 'Wielkość (m2)'
      end
      cell.next_sibling.next_sibling.text.to_f if cell
    end
  end
end
