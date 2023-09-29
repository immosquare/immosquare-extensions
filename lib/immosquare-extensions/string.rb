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
  ## "true".to_boolean  => true
  ## "false".to_boolean => false
  ## "random".to_boolean => nil
  ##============================================================##
  def to_boolean
    case downcase
    when "true"
      true
    when "false"
      false
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

  ##============================================================##
  ## Overriding the standard upcase method to provide a more
  ## comprehensive version that correctly handles Unicode characters.
  ##
  ## Example:
  ## "José".upcase => "JOSÉ"
  ##============================================================##
  def upcase
    UnicodeUtils.upcase(self)
  end

end
