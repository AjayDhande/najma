require_relative "bundle_order"
require "test/unit"

class TestCase7 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('5 IMG').calculate_bundle
  end
end