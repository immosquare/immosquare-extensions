require "rails"

module ImmosquareExtensions
  class Railtie < Rails::Railtie

    initializer "immosquare_extensions.action_view" do
      ActiveSupport.on_load(:action_view) do
        include ImmosquareExtensions::PreviewMailerHelper
      end
    end

    initializer "immosquare_extensions.active_record" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.include(ImmosquareExtensions::ApplicationRecord)
      end
    end


  end
end
