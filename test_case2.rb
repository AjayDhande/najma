require_relative "bundle_order"
require "test/unit"

class TestCase2 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('10 IMG 5 FLAC 3 VID').calculate_bundle
  end
end