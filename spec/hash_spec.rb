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
    it "should remove specified keys" do
      expect(simple_hash.without(:a, :b)).to(eq({:c => 3}))
    end
  end


  describe "#depth" do
    it "should return depth of simple hash" do
      expect(simple_hash.depth).to(eq(1))
    end

    it "should return depth of nested hash" do
      expect(nested_hash.depth).to(eq(3))
    end
  end

  describe "#sort_by_key" do
    it "should sort hash by its keys" do
      expect(mixed_hash.sort_by_key(:recursive => false)).to(eq({:a => {:d => 4, :c => 3}, :b => 1}))
    end

    it "should recursively sort nested hashes by its keys" do
      expect(mixed_hash.sort_by_key).to(eq({:a => {:c => 3, :d => 4}, :b => 1}))
    end
  end

  describe "#flatten_hash" do
    it "should flatten nested hash to single level" do
      expect(nested_hash.flatten_hash).to(eq({:"a.b.c"=>1}))
    end
  end
end
