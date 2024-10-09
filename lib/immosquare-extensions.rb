##============================================================##
## Shared Methods (Need to be loaded first)
##============================================================##
require_relative "immosquare-extensions/shared_methods"

##============================================================##
## Extensions
##============================================================##
require_relative "immosquare-extensions/application_record"
require_relative "immosquare-extensions/array"
require_relative "immosquare-extensions/file"
require_relative "immosquare-extensions/hash"
require_relative "immosquare-extensions/string"
##============================================================##
## Rails
##============================================================##
require_relative "immosquare-extensions/railtie" if defined?(Rails)

module ImmosquareExtensions
end
