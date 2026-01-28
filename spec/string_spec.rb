require "active_support/core_ext/string/inflections"
require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/string_spec.rb
##============================================================##
RSpec.describe(String) do
  describe "#to_boolean" do
    it "converts 'true' to true" do
      expect("true".to_boolean).to(eq(true))
    end

    it "converts 'false' to false" do
      expect("false".to_boolean).to(eq(false))
    end

    it "converts other strings to nil" do
      expect("random_string".to_boolean).to(be_nil)
    end

    it "is case-insensitive for 'true'" do
      expect("TrUe".to_boolean).to(eq(true))
    end

    it "is case-insensitive for 'false'" do
      expect("FaLsE".to_boolean).to(eq(false))
    end

    it "returns default_value for non-boolean strings" do
      expect("random".to_boolean(true)).to(eq(true))
      expect("random".to_boolean(false)).to(eq(false))
      expect("random".to_boolean("default")).to(eq("default"))
    end
  end

  describe "#titleize_custom" do
    it "titleizes a simple string" do
      expect("hello world".titleize_custom).to(eq("Hello World"))
    end

    it "preserves hyphens in the string" do
      expect("SANT-ANDREA-D'ORCINO".titleize_custom).to(eq("Sant-Andrea-D'orcino"))
    end

    it "handles lowercase hyphenated strings" do
      expect("jean-pierre".titleize_custom).to(eq("Jean-Pierre"))
    end

    it "handles strings with apostrophes" do
      expect("o'brien".titleize_custom).to(eq("O'brien"))
    end
  end
end
