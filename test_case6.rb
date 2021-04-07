require_relative "bundle_order"
require "test/unit"

class TestCase6 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('10').calculate_bundle
  end
end