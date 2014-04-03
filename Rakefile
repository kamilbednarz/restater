require File.dirname(__FILE__) + "/lib/restater.rb"

task :default => [:ingest]

task :ingest do
  walker = Restater::Walker.new(:link => 'http://www.gumtree.pl/fp-domy-i-mieszkania-sprzedam-i-kupie/krakow/c9073l3200208',
                                :num_pages => 1)
  walker.run
end
