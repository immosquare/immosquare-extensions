##============================================================##
## Shared Methods (Need to be loaded first)
##============================================================##
require_relative "immosquare-extensions/shared_methods"

##============================================================##
## Extensions
##============================================================##
require_relative "immosquare-extensions/application_record"
require_relative "immosquare-extensions/application_record_history"
require_relative "immosquare-extensions/array"
require_relative "immosquare-extensions/file"
require_relative "immosquare-extensions/hash"
require_relative "immosquare-extensions/string"

##============================================================##
## Helpers
##============================================================##
require_relative "immosquare-extensions/helpers/preview_mailer_helper"

##============================================================##
## Rails
##============================================================##
require_relative "immosquare-extensions/railtie" if defined?(Rails)


module ImmosquareExtensions
end
