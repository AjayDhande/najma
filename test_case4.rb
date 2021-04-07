require_relative "bundle_order"
require "test/unit"

class TestCase4 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('10 ImG 15 FLaC 13 Vid').calculate_bundle
  end
end