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
        ##============================================================##
        ## Pour ajouter des méthodes à ActiveRecord::Base
        ##============================================================##
        ActiveRecord::Base.include(ImmosquareExtensions::ApplicationRecord)

        ##============================================================##
        ## Pour ajouter une gestion de l'historique des modifications
        ##============================================================##
        extend ImmosquareExtensions::ApplicationRecordHistory::ClassMethods

        ##============================================================##
        ## Définir la classe HistoryRecord après le chargement d'ActiveRecord
        ##============================================================##
        require "immosquare-extensions/models/history_record"
      end
    end


  end
end
