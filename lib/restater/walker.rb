require 'nokogiri'
require 'open-uri'

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
      while @counter <= @pages_to_process
        links = self.get_offer_links(load_page)

        results = links[0..3].map { |link| Result.from_url(link) }
        puts results.map { |a| [a.title, a.price, a.size].inspect }

        @counter += 1
      end
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
