require File.dirname(__FILE__) + "/lib/restater.rb"

task :default => [:ingest]

task :ingest do
  url = 'https://www.gumtree.pl/s-mieszkania-i-domy-sprzedam-i-kupie/krakow/v1c9073l3200208p1'
  walker = Restater::Walker.new(url: url, pages: 1)
  offers = walker.read_offers

  puts offers.inspect
end
