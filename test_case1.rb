require_relative "bundle_order"
require "test/unit"

class TestCase1 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('10 IMG 15 FLAC 13 VID').calculate_bundle
  end
end