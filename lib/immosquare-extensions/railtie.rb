require "rails"

module ImmosquareExtensions
  class Railtie < Rails::Railtie

    initializer "immosquare_extensions.action_view" do
      ActiveSupport.on_load(:action_view) do
        include ImmosquareExtensions::PreviewMailerHelper
      end
    end

  end
end
