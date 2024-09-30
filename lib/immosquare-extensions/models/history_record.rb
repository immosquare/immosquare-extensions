module ImmosquareExtensions
  module ApplicationRecordHistory
    ##============================================================##
    ## On nome le modèle différemment que ApplicationRecordHistory
    ## pour éviter les conflits avec le nom du module.
    ##============================================================##
    class HistoryRecord < ::ActiveRecord::Base

      self.table_name = "application_record_histories"

      belongs_to :recordable, :polymorphic => true
      serialize :data, :coder => JSON

    end
  end
end
