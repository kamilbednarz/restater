require 'nokogiri'
require 'open-uri'
require 'json'

module Restater
  class Walker

    def initialize params
      @link = params[:link]
      @pages_to_process = params[:num_pages]
      @counter = 1
    end

    def link
      @link
    end

    def load_page
      Nokogiri::HTML(open("#{@link}?Page=#{@counter}"))
    end

    def run
      results = []
      while @counter <= @pages_to_process
        puts "Analyzing page #{@counter}..."
        links = self.get_offer_links(load_page)

        matches = links.map { |link| Result.from_url(link) }
        results << matches.select(&:is_valid?).map { |m| {:count => m.price_per_square_meter.to_i, :lat => m.coordinates[0], :lng => m.coordinates[1]}}
        @counter += 1
      end
      puts results.flatten.to_json
      results.flatten
    end

    def get_offer_links page
      filter_out_ads(page.css('tr[class="resultsTableSB rrow"]')).map do |tr|
        tr.css("div[class=ar-title] a").attribute('href')
      end
    end

    def go_to_next_page

    end

    private

    def filter_out_ads trs
      trs.select do |tr|
        id = tr.attribute('id')
        id && id.value.start_with?('resultRow')
      end
    end
  end
end
