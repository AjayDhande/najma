require_relative "bundle_order"
require "test/unit"

class TestCase5 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('5 FLAC').calculate_bundle
  end
end