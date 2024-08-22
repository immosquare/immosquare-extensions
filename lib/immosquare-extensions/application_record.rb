
module ImmosquareExtensions
  module ApplicationRecord
    ##============================================================##
    ## On ajoute une méthode dig pour pouvoir accéder à des
    ## attributs imbriqués sans avoir à vérifier si les objets
    ## user.dig(:user_profile, :user_card_type, :slug)
    ##============================================================##
    def dig(*keys)
      keys.reduce(self) do |obj, key|
        obj.respond_to?(key) ? obj.send(key) : nil
      end
    end
  end
end
