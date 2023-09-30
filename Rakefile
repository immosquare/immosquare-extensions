require "json"
require "immosquare-extensions"

namespace :immosquare_extensions do
  namespace :sample do
    ##============================================================##
    ## bundle exec rake immosquare_extensions:sample:hash
    ##============================================================##
    task :depth do
      hash = {:a => 1, :b => {:c => 2, :d => {:e => 3}}}
      puts hash.depth
    end
  end
end
