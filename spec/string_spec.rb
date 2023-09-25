require "immosquare-extensions/string"

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
  end
end
