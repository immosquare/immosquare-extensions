require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/array_spec.rb
##============================================================##
RSpec.describe(Array) do
  let(:simple_array) { [2, 4, 6] }


  describe "#to_boolean" do
    it "should return mean of array" do
      expect(simple_array.mean).to(eq(4.0))
    end
  end
end
