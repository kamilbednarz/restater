require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

module Restater
  class Walker
    attr_accessor :url, :offers

    def initialize(url:, pages: 1)
      @url = url
      @pages_limit = pages
      @offers = []
    end

    def read_offers
      each_page do |page|
        each_offer_anchor(page) do |offer|
          offers << OfferBuilder.new(offer).build
        end
      end
      offers
    end

    private

    attr_reader :pages_limit

    def each_page
      #TBD
      next_link = url
      pages_limit.times do
        page = Nokogiri::HTML(open(next_link))
        yield page
        #next_link = get_next_page_link(page)
      end
    end

    def each_offer_anchor(page_html)
      page_html.css('.result-link .title a.href-link').each do |anchor|
        yield(construct_absolute_url(anchor.attribute('href')))
      end
    end

    # def run
    #   results = []
    #   while @counter <= @pages_to_process
    #     puts "Analyzing page #{@counter}..."
    #     links = self.get_offer_links(load_page)
    #
    #     matches = links.map { |link| Result.from_url(link) }
    #     results << matches.select(&:is_valid?).map { |m| {:count => m.price_per_square_meter.to_i, :lat => m.coordinates[0], :lng => m.coordinates[1]}}
    #     @counter += 1
    #   end
    #   puts results.flatten.to_json
    #   results.flatten
    # end

    def get_next_page_link(page)
      # TBD
    end

    def construct_absolute_url(path)
      "https://gumtree.pl#{path}"
    end
  end
end
