module Restater
  class Offer
    attr_accessor :link, :title, :size, :description, :location, :price

    def initialize(options = {})
      @link = options[:link]
      @title = options[:title]
      @description = options[:description]
      @location = options[:location]
      @price = options[:price]
    end

    def valid?
      price && price > 0 && size > 0 && price_per_square_meter > 2000 &&
        price_per_square_meter < 25000 && location.present? &&
        coordinates.present? && coordinates != [50.06465009999999, 19.9449799]
    end

    def price_per_square_meter
      price / area if area > 0
    end

    def to_s
      "#{location} - #{price}"
    end
  end
end
