##============================================================##
## This extension adds utility methods to the String class.
##============================================================##
class String

  ##============================================================##
  ## Particles that stay lowercase inside a place name, unless they
  ## open it. `d` and `l` cover the elided forms `d'` and `l'`.
  ##============================================================##
  TITLEIZE_PARTICLES_FRENCH = ["à", "au", "aux", "d", "de", "des", "du", "en", "ès", "et", "l", "la", "le", "les", "lès", "sous", "sur"].freeze

  ##============================================================##
  ## A capital after an apostrophe belongs to an elision or a
  ## patronymic prefix (d'Orcino, O'Brien, N'Djamena), never to an
  ## English clitic (King's, It's). Both sides are closed sets, so
  ## the rule needs no language detection: the prefix decides and
  ## the suffix vetoes.
  ##============================================================##
  TITLEIZE_ELISIONS = ["c", "d", "j", "l", "m", "n", "o", "qu", "s", "t"].freeze
  TITLEIZE_CLITICS  = ["d", "ll", "m", "re", "s", "t", "ve"].freeze

  private_constant(:TITLEIZE_PARTICLES_FRENCH, :TITLEIZE_ELISIONS, :TITLEIZE_CLITICS)

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
  ## Titleize a PLACE NAME under French typographic rules: the
  ## letter after an apostrophe carries the capital, and particles
  ## stay lowercase unless they open the name. Hyphenated toponyms
  ## are the case standard `titleize` gets wrong.
  ##
  ## Use `titleize_name` for anything that is not a place — there,
  ## no particle is lowered.
  ##
  ## Examples:
  ## "SANT-ANDREA-D'ORCINO".titleize_place     => Sant-Andrea-d'Orcino
  ## "saint-jean-sur-richelieu".titleize_place => Saint-Jean-sur-Richelieu
  ## "st john's".titleize_place                => St John's
  ## "SANT-ANDREA-D'ORCINO".titleize            => Sant Andrea D'orcino
  ##============================================================##
  def titleize_place
    titleize_words(:lower_particles => true)
  end

  ##============================================================##
  ## Titleize a proper name or a label — a person, an agency, a
  ## building, an enumeration value. Same apostrophe and accent
  ## handling as `titleize_place`, but every word is capitalized.
  ##
  ## Examples:
  ## "o'brien".titleize_name          => O'Brien
  ## "MAISON DE VILLE".titleize_name  => Maison De Ville
  ##============================================================##
  def titleize_name
    titleize_words(:lower_particles => false)
  end

  ##============================================================##
  ## The helpers below are private on every String in the process:
  ## a new public extension must be added ABOVE this line.
  ##============================================================##
  private

  ##============================================================##
  ## `humanize` normalizes first: it folds underscores into spaces
  ## and downcases the tail, so an all-caps source comes back
  ## readable.
  ##
  ## The scan keeps letters, digits and apostrophes in a single
  ## match, so `d'howard` arrives as ONE word and its two halves
  ## can be ruled on separately. Hyphens and spaces stay untouched
  ## between the matches, which is how the shape of the original
  ## string survives.
  ##
  ## Known limits of that pair, each frozen by a characterization
  ## test: internal capitals are flattened (MacDonald → Macdonald),
  ## a dotted abbreviation reads as a particle (`n.-d.-de-grâce` →
  ## `N.-d.-de-Grâce`) and roman numerals are recapitalized (Louis
  ## XIV → Louis Xiv).
  ##============================================================##
  def titleize_words(lower_particles:)
    first = true

    humanize.gsub(/[\p{L}\p{N}'’]+/) do |word|
      titleized = titleize_single_word(word, :first => first, :lower_particles => lower_particles)
      first     = false
      titleized
    end
  end

  def titleize_single_word(word, first:, lower_particles:)
    ##============================================================##
    ## Split on the FIRST apostrophe only — a second one belongs to
    ## the name itself. The prefix follows the particle rule; the
    ## suffix takes a capital only after an elision, so a
    ## possessive stays intact: "King's", never "King'S".
    ##============================================================##
    if word =~ /['’]/
      separator      = word[/['’]/]
      prefix, suffix = word.split(/['’]/, 2)
      suffix         = suffix.capitalize if elision?(prefix, suffix)
      return "#{titleize_particle(prefix, :first => first, :lower_particles => lower_particles)}#{separator}#{suffix}"
    end

    titleize_particle(word, :first => first, :lower_particles => lower_particles)
  end

  def elision?(prefix, suffix)
    TITLEIZE_ELISIONS.include?(prefix.downcase) && !TITLEIZE_CLITICS.include?(suffix.downcase)
  end

  def titleize_particle(word, first:, lower_particles:)
    return word.downcase if lower_particles && !first && TITLEIZE_PARTICLES_FRENCH.include?(word.downcase)

    word.capitalize
  end

end
