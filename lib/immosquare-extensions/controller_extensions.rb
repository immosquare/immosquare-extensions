module ImmosquareExtensions
  module ControllerExtensions
    extend ActiveSupport::Concern

    included do
      before_action :set_current_modifier
    end

    private

    def set_current_modifier
      modifier_method = ImmosquareExtensions::ApplicationRecordHistory.current_modifier_method || :current_user
      ImmosquareExtensions::Current.modifier = (send(modifier_method) if respond_to?(modifier_method, true))
    end
  end
end
