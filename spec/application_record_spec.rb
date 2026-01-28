require "immosquare-extensions"
require "spec_helper"

##============================================================##
## bundle exec rspec spec/application_record_spec.rb
##============================================================##

##============================================================##
## Mock classes to simulate ActiveRecord behavior
##============================================================##
class MockUserProfile
  include ImmosquareExtensions::ApplicationRecord

  attr_accessor :card_type

  def initialize(card_type)
    @card_type = card_type
  end
end

class MockCardType
  include ImmosquareExtensions::ApplicationRecord

  attr_accessor :slug

  def initialize(slug)
    @slug = slug
  end
end

class MockUser
  include ImmosquareExtensions::ApplicationRecord

  attr_accessor :name, :profile

  def initialize(name, profile = nil)
    @name = name
    @profile = profile
  end
end

RSpec.describe(ImmosquareExtensions::ApplicationRecord) do
  describe "#dig" do
    let(:card_type) { MockCardType.new("premium") }
    let(:profile)   { MockUserProfile.new(card_type) }
    let(:user)      { MockUser.new("John", profile) }

    it "returns attribute value for single key" do
      expect(user.dig(:name)).to(eq("John"))
    end

    it "returns nested attribute value for multiple keys" do
      expect(user.dig(:profile, :card_type, :slug)).to(eq("premium"))
    end

    it "returns nil when intermediate key does not exist" do
      expect(user.dig(:profile, :nonexistent, :slug)).to(be_nil)
    end

    it "returns nil when final key does not exist" do
      expect(user.dig(:profile, :card_type, :nonexistent)).to(be_nil)
    end

    it "returns nil for non-existent attribute on first level" do
      expect(user.dig(:nonexistent)).to(be_nil)
    end

    it "handles nil intermediate values" do
      user_without_profile = MockUser.new("Jane", nil)
      expect(user_without_profile.dig(:profile, :card_type)).to(be_nil)
    end
  end
end
