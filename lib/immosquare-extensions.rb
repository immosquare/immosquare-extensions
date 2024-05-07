require_relative "immosquare-extensions/shared_methods"
require_relative "immosquare-extensions/array"
require_relative "immosquare-extensions/file"
require_relative "immosquare-extensions/hash"
require_relative "immosquare-extensions/string"
require_relative "immosquare-extensions/helpers/preview_mailer_helper"
require_relative "immosquare-extensions/railtie" if defined?(Rails)

module ImmosquareExtensions
end
