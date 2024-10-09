require "rails"

module ImmosquareExtensions
  class Railtie < Rails::Railtie

    initializer "immosquare_extensions.active_record" do
      ActiveSupport.on_load(:active_record) do
        ##============================================================##
        ## Pour ajouter des méthodes à ActiveRecord::Base
        ##============================================================##
        ActiveRecord::Base.include(ImmosquareExtensions::ApplicationRecord)
      end
    end

  end
end
