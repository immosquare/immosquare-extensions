require "active_support/core_ext/string/inflections"
require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/string_spec.rb
##============================================================##
RSpec.describe(String) do
  ##============================================================##
  ## Official registers are the truth table of `titleize_place`:
  ## every entry is a real place name with the spelling its own
  ## register uses.
  ##============================================================##
  let(:official_place_names) do
    {
      "saint-louis-du-ha! ha!"          => "Saint-Louis-du-Ha! Ha!",
      "sainte-anne-de-la-pérade"        => "Sainte-Anne-de-la-Pérade",
      "saint-pierre-de-l'île-d'orléans" => "Saint-Pierre-de-l'Île-d'Orléans",
      "notre-dame-des-sept-douleurs"    => "Notre-Dame-des-Sept-Douleurs",
      "île-à-la-crosse"                 => "Île-à-la-Crosse",
      "riom-ès-montagnes"               => "Riom-ès-Montagnes",
      "l'haÿ-les-roses"                 => "L'Haÿ-les-Roses",
      "aix-en-provence"                 => "Aix-en-Provence",
      "pont-à-mousson"                  => "Pont-à-Mousson",
      "bœuf-sur-mer"                    => "Bœuf-sur-Mer",
      "st john's"                       => "St John's",
      "val-d'or"                        => "Val-d'Or"
    }
  end

  ##============================================================##
  ## Degenerate input: nothing here may raise, and the surprising
  ## outputs are `humanize` doing an lstrip without an rstrip.
  ##============================================================##
  let(:degenerate_inputs) do
    ["", "   ", "  le mans  ", "le  mans", "-le mans-", "le\tmans", "le\nmans", "'", "d'", "café & bar"]
  end

  describe("#to_boolean") do
    it("converts 'true' to true") do
      expect("true".to_boolean).to(eq(true))
    end

    it("converts 'false' to false") do
      expect("false".to_boolean).to(eq(false))
    end

    it("converts other strings to nil") do
      expect("random_string".to_boolean).to(be_nil)
    end

    it("is case-insensitive for 'true'") do
      expect("TrUe".to_boolean).to(eq(true))
    end

    it("is case-insensitive for 'false'") do
      expect("FaLsE".to_boolean).to(eq(false))
    end

    it("returns default_value for non-boolean strings") do
      expect("random".to_boolean(true)).to(eq(true))
      expect("random".to_boolean(false)).to(eq(false))
      expect("random".to_boolean("default")).to(eq("default"))
    end
  end

  ##============================================================##
  ## The place-name variant lowercases French particles inside the
  ## name. Every expectation below is a real toponym, spelled as its
  ## official register spells it.
  ##============================================================##
  describe("#titleize_place") do
    it("titleizes a simple string") do
      expect("hello world".titleize_place).to(eq("Hello World"))
    end

    it("preserves hyphens in the string") do
      expect("SANT-ANDREA-D'ORCINO".titleize_place).to(eq("Sant-Andrea-d'Orcino"))
    end

    it("handles lowercase hyphenated strings") do
      expect("jean-pierre".titleize_place).to(eq("Jean-Pierre"))
    end

    ##============================================================##
    ## The letter after an apostrophe carries the name, so it is
    ## the one that gets the capital — not the elided particle.
    ##============================================================##
    it("capitalizes the letter following an apostrophe") do
      expect("o'brien".titleize_place).to(eq("O'Brien"))
      expect("saint-adolphe-d'howard".titleize_place).to(eq("Saint-Adolphe-d'Howard"))
      expect("VAL-D'OR".titleize_place).to(eq("Val-d'Or"))
      expect("n'djamena".titleize_place).to(eq("N'Djamena"))
    end

    it("handles the typographic apostrophe like the straight one") do
      expect("l’assomption".titleize_place).to(eq("L’Assomption"))
      expect("val-d’or".titleize_place).to(eq("Val-d’Or"))
    end

    ##============================================================##
    ## An English possessive is not an elision: only a one or two
    ## letter prefix takes a capital after the apostrophe, so the
    ## `s` of a genitive stays lowercase.
    ##============================================================##
    it("leaves an English possessive lowercase") do
      expect("st john's".titleize_place).to(eq("St John's"))
      expect("king's landing".titleize_place).to(eq("King's Landing"))
      expect("martha's vineyard".titleize_place).to(eq("Martha's Vineyard"))
      expect("aujourd'hui".titleize_place).to(eq("Aujourd'hui"))
    end

    it("capitalizes accented initials") do
      expect("montréal".titleize_place).to(eq("Montréal"))
      expect("l'île-perrot".titleize_place).to(eq("L'Île-Perrot"))
      expect("sainte-émélie-de-l'énergie".titleize_place).to(eq("Sainte-Émélie-de-l'Énergie"))
    end

    ##============================================================##
    ## `humanize` only downcases ASCII, so an all-caps accented
    ## source reaches the capitalization pass with its accents
    ## still uppercase.
    ##============================================================##
    it("capitalizes accented initials from an all-caps source") do
      expect("MONTRÉAL".titleize_place).to(eq("Montréal"))
      expect("SAINTE-ÉMÉLIE-DE-L'ÉNERGIE".titleize_place).to(eq("Sainte-Émélie-de-l'Énergie"))
    end

    ##============================================================##
    ## A particle keeps its lowercase inside the name and takes a
    ## capital when it opens it — the two halves of the same rule.
    ##============================================================##
    it("lowercases particles inside a place name") do
      expect("saint-jean-sur-richelieu".titleize_place).to(eq("Saint-Jean-sur-Richelieu"))
      expect("notre-dame-de-l'île-perrot".titleize_place).to(eq("Notre-Dame-de-l'Île-Perrot"))
      expect("les sables-d'olonne".titleize_place).to(eq("Les Sables-d'Olonne"))
    end

    it("capitalizes a particle that opens the name") do
      expect("l'assomption".titleize_place).to(eq("L'Assomption"))
      expect("le mans".titleize_place).to(eq("Le Mans"))
    end

    it("folds underscores into spaces, as humanize does") do
      expect("hello_world".titleize_place).to(eq("Hello World"))
    end

    it("matches the official spelling of real place names") do
      official_place_names.each do |input, expected|
        expect(input.titleize_place).to(eq(expected))
      end
    end

    ##============================================================##
    ## Idempotence is the property that matters in production: a
    ## column titleized twice must not drift. Checked on inputs and
    ## on outputs, which is what an example-by-example suite cannot
    ## guarantee.
    ##============================================================##
    it("is idempotent") do
      (official_place_names.keys + official_place_names.values + degenerate_inputs).each do |value|
        titleized = value.titleize_place
        expect(titleized.titleize_place).to(eq(titleized))
      end
    end

    it("leaves degenerate input alone instead of raising") do
      expect(degenerate_inputs.map(&:titleize_place)).to(eq([
                                                              "", "", "Le Mans  ", "Le  Mans", "-Le Mans-", "Le\tMans", "Le\nMans", "'", "D'", "Café & Bar"
                                                            ]))
    end
  end

  ##============================================================##
  ## `titleize_name` is the variant for everything that is NOT a
  ## place. It shares the apostrophe and accent handling, and
  ## lowers no particle.
  ##============================================================##
  describe("#titleize_name") do
    it("capitalizes the letter following an apostrophe") do
      expect("o'brien".titleize_name).to(eq("O'Brien"))
    end

    it("leaves an English possessive lowercase") do
      expect("mcdonald's".titleize_name).to(eq("Mcdonald's"))
    end

    it("capitalizes accented initials") do
      expect("émilie".titleize_name).to(eq("Émilie"))
    end

    it("keeps particles capitalized") do
      expect("MAISON DE VILLE".titleize_name).to(eq("Maison De Ville"))
      expect("jean de la fontaine".titleize_name).to(eq("Jean De La Fontaine"))
    end

    it("capitalizes a particle that opens the name") do
      expect("de vinci".titleize_name).to(eq("De Vinci"))
    end
  end
  ##============================================================##
  ## Behaviours known to be wrong, frozen on purpose: the day
  ## someone fixes one, this test fails, which is the intended
  ## signal. All three come from `humanize` or from the word scan,
  ## none from the particle rule.
  ##============================================================##
  describe("known limitations") do
    it("flattens internal capitals") do
      expect("MacDonald".titleize_name).to(eq("Macdonald"))
      expect("eBay".titleize_name).to(eq("Ebay"))
    end

    it("reads a dotted abbreviation as a particle") do
      expect("n.-d.-de-grâce".titleize_place).to(eq("N.-d.-de-Grâce"))
    end

    it("recapitalizes roman numerals") do
      expect("louis xiv".titleize_name).to(eq("Louis Xiv"))
    end
  end
end
