require_relative "bundle_order"
require "test/unit"

class TestCase8 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('').calculate_bundle
  end
end