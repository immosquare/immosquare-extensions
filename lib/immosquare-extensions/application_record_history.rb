require "active_support/concern"

module ImmosquareExtensions
  module ApplicationRecordHistory
    extend ActiveSupport::Concern

    module ClassMethods
      def immosquare_history(options = {})
        ##============================================================##
        ## Inclut les méthodes d'instance nécessaires
        ##============================================================##
        include(ImmosquareExtensions::ApplicationRecordHistory::InstanceMethods)

        ##============================================================##
        ## Stocker les options dans un attribut de classe
        ##============================================================##
        class_attribute(:immosquare_history_options)
        self.immosquare_history_options = options

        ##============================================================##
        ## Configure le callback after_save
        ##============================================================##
        after_save(:save_change_history)
      end
    end

    module InstanceMethods
      private

      def save_change_history
        ##============================================================##
        ## Récupérer les champs à exclure depuis les options
        ##============================================================##
        excluded_fields = self.class.immosquare_history_options[:except] || []
        excluded_fields += [:created_at, :updated_at]
        changes_to_save = previous_changes.except(*excluded_fields.uniq.map(&:to_s))

        ##============================================================##
        ## Si aucun changement à sauvegarder, on sort
        ##============================================================##
        nil if changes_to_save.none?
      end
    end
  end
end
