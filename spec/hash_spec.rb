require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/hash_spec.rb
##============================================================##
describe Hash do
  let(:simple_hash) { {:a => 1, :b => 2, :c => 3} }
  let(:nested_hash) { {:a => {:b => {:c => 1}}} }
  let(:mixed_hash)  { {:b => 1, :a => {:d => 4, :c => 3}} }

  describe "#without" do
    it "removes specified keys" do
      expect(simple_hash.without(:a, :b)).to(eq({:c => 3}))
    end

    it "returns original hash when no keys specified" do
      expect(simple_hash.without).to(eq(simple_hash))
    end

    it "ignores non-existent keys" do
      expect(simple_hash.without(:x, :y)).to(eq(simple_hash))
    end
  end

  describe "#depth" do
    it "returns depth of simple hash" do
      expect(simple_hash.depth).to(eq(1))
    end

    it "returns depth of nested hash" do
      expect(nested_hash.depth).to(eq(3))
    end

    it "returns 0 for empty hash" do
      expect({}.depth).to(eq(0))
    end
  end

  describe "#sort_by_key" do
    it "sorts hash by its keys" do
      expect(mixed_hash.sort_by_key(:recursive => false)).to(eq({:a => {:d => 4, :c => 3}, :b => 1}))
    end

    it "recursively sorts nested hashes by its keys" do
      expect(mixed_hash.sort_by_key).to(eq({:a => {:c => 3, :d => 4}, :b => 1}))
    end

    it "is case-insensitive" do
      input = {"B" => 1, "a" => 2}
      expect(input.sort_by_key.keys).to(eq(["a", "B"]))
    end

    it "accepts a custom sorting block" do
      input = {:b => 1, :a => 2, :c => 3}
      result = input.sort_by_key { |a, b| b <=> a }
      expect(result.keys).to(eq([:c, :b, :a]))
    end
  end

  describe "#flatten_hash" do
    it "flattens nested hash to single level" do
      expect(nested_hash.flatten_hash).to(eq({:"a.b.c" => 1}))
    end

    it "returns same hash for already flat hash" do
      expect(simple_hash.flatten_hash).to(eq(simple_hash))
    end

    it "handles mixed nested and flat keys" do
      input = {:a => 1, :b => {:c => 2}}
      expect(input.flatten_hash).to(eq({:a => 1, :"b.c" => 2}))
    end
  end

  describe "#to_beautiful_json" do
    it "returns empty hash as '{}'" do
      expect({}.to_beautiful_json).to(eq("{}"))
    end

    it "formats a simple hash with aligned values" do
      input = {:a => 1, :bb => 2}
      result = input.to_beautiful_json
      expect(result).to(include("\"a\":"))
      expect(result).to(include("\"bb\":"))
    end

    it "formats nested hashes" do
      input = {:a => {:b => 1}}
      result = input.to_beautiful_json
      expect(result).to(include("\"a\":"))
      expect(result).to(include("\"b\":"))
    end

    it "handles string values with special characters" do
      input = {:text => "line1\nline2\ttab"}
      result = input.to_beautiful_json
      expect(result).to(include("\\n"))
      expect(result).to(include("\\t"))
    end

    it "handles null values" do
      input = {:value => nil}
      result = input.to_beautiful_json
      expect(result).to(include("null"))
    end

    it "handles boolean values" do
      input = {:active => true, :deleted => false}
      result = input.to_beautiful_json
      expect(result).to(include("true"))
      expect(result).to(include("false"))
    end

    it "respects align option" do
      input = {:a => 1, :long_key => 2}
      aligned = input.to_beautiful_json(:align => true)
      not_aligned = input.to_beautiful_json(:align => false)
      expect(aligned).not_to(eq(not_aligned))
    end

    it "respects indent_size option" do
      input = {:a => 1}
      result = input.to_beautiful_json(:indent_size => 4)
      expect(result).to(include("    \"a\":"))
    end

    it "formats single-key nested hash on one line" do
      input = {:outer => {:inner => 1}}
      result = input.to_beautiful_json
      expect(result).to(include("{\"inner\": 1}"))
    end

    it "does not collapse single-key hash when value is an array" do
      input = {:outer => {:items => [1, 2, 3]}}
      result = input.to_beautiful_json
      expect(result.scan("\n").count).to(be > 2)
    end

    it "handles carriage return and backslash in strings" do
      input = {:text => "line1\rline2\\end"}
      result = input.to_beautiful_json
      expect(result).to(include("\\r"))
      expect(result).to(include("\\\\"))
    end

    it "handles numeric values" do
      input = {:integer => 42, :float => 3.14}
      result = input.to_beautiful_json
      expect(result).to(include("42"))
      expect(result).to(include("3.14"))
    end
  end
end
