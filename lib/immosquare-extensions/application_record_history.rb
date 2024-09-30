require "active_support/concern"

module ImmosquareExtensions
  module ApplicationRecordHistory
    extend ActiveSupport::Concern

    module ClassMethods
      def track_application_record(options = {})
        ##============================================================##
        ## Inclut les méthodes d'instance nécessaires
        ##============================================================##
        include(ImmosquareExtensions::ApplicationRecordHistory::InstanceMethods)

        ##============================================================##
        ## Stocker les options dans un attribut de classe
        ##============================================================##
        class_attribute(:history_options)
        self.history_options = options

        ##============================================================##
        ## Configure le callback after_save
        ##============================================================##
        after_save(:save_change_history)
      end
    end

    module InstanceMethods
      private

      def save_change_history
        history_options = self.class.history_options

        ##============================================================##
        ## Récupérer les champs à observer
        ##============================================================##
        changes_to_save =
          if history_options[:only].present?
            previous_changes.slice(*history_options[:only].map(&:to_s))
          else
            excluded_fields = history_options[:except] || []
            excluded_fields += [:created_at, :updated_at]
            previous_changes.except(*excluded_fields.uniq.map(&:to_s))
          end

        ##============================================================##
        ## Si aucun changement à sauvegarder, on sort
        ##============================================================##
        return if changes_to_save.none?

        JulesLogger.info("on doit save les changements")
        JulesLogger.info(changes_to_save)
      end
    end
  end
end
