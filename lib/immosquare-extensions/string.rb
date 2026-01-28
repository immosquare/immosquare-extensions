require "unicode_utils/upcase"

##============================================================##
## This extension adds utility methods to the String class.
##============================================================##
class String

  ##============================================================##
  ## Convert the string 'true' to true and 'false' to false.
  ## Any other value will return nil.
  ##
  ## Examples:
  ## "true".to_boolean          => true
  ## "false".to_boolean         => false
  ## "random".to_boolean        => nil
  ## "random".to_boolean(true)  => true
  ##============================================================##
  def to_boolean(default_value = nil)
    case downcase
    when "true"
      true
    when "false"
      false
    else
      default_value
    end
  end

  ##============================================================##
  ## Provide a custom titleize method to handle strings
  ## especially ones with hyphens more appropriately.
  ## Standard titleize does not preserve hyphens in the desired manner.
  ##
  ## Reference:
  ## https://stackoverflow.com/questions/29784873/titleize-a-hyphenated-name
  ##
  ## Examples:
  ## "SANT-ANDREA-D'ORCINO".titleize_custom => Sant-Andrea-D'orcino
  ## "SANT-ANDREA-D'ORCINO".titleize        => Sant Andrea D'orcino
  ##============================================================##
  def titleize_custom
    humanize.gsub(/\b('?[a-z])/) { ::Regexp.last_match(1).capitalize }
  end

end
