require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/array_spec.rb
##============================================================##
RSpec.describe(Array) do
  describe "#mean" do
    it "returns the mean of an array of integers" do
      expect([2, 4, 6].mean).to(eq(4.0))
    end

    it "returns the mean of an array of floats" do
      expect([1.5, 2.5, 3.0].mean).to(eq(2.3333333333333335))
    end

    it "returns the mean of a single element array" do
      expect([5].mean).to(eq(5.0))
    end

    it "returns Float::NAN for an empty array" do
      expect([].mean.nan?).to(be(true))
    end
  end

  describe "#to_beautiful_json" do
    it "returns empty array as '[]'" do
      expect([].to_beautiful_json).to(eq("[]"))
    end

    it "formats a single element array on one line" do
      expect([42].to_beautiful_json).to(eq("[42]"))
    end

    it "formats a single string element array on one line" do
      expect(["hello"].to_beautiful_json).to(eq("[\"hello\"]"))
    end

    it "formats multiple elements with newlines" do
      result = [1, 2, 3].to_beautiful_json
      expect(result).to(include("\n"))
      expect(result).to(start_with("[\n"))
      expect(result).to(end_with("\n]"))
    end

    it "formats an array of hashes" do
      input = [{"name" => "Alice"}, {"name" => "Bob"}]
      result = input.to_beautiful_json
      expect(result).to(include("\"name\":"))
      expect(result).to(include("Alice"))
      expect(result).to(include("Bob"))
    end

    it "respects indent_size option" do
      result = [1, 2].to_beautiful_json(:indent_size => 4)
      expect(result).to(include("    1"))
    end

    it "formats single hash element with newlines (not on one line)" do
      result = [{"name" => "Alice"}].to_beautiful_json
      expect(result).to(include("\n"))
    end

    it "handles nested arrays" do
      result = [[1, 2], [3, 4]].to_beautiful_json
      expect(result).to(include("[\n"))
      expect(result.scan("[").count).to(eq(3))
    end

    it "handles mixed types in array" do
      result = [1, "text", true, nil].to_beautiful_json
      expect(result).to(include("1"))
      expect(result).to(include("\"text\""))
      expect(result).to(include("true"))
      expect(result).to(include("null"))
    end
  end
end
