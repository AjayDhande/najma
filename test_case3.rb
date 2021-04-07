require_relative "bundle_order"
require "test/unit"

class TestCase3 < Test::Unit::TestCase

  def test_simple
    BundleOrder.new('1 IMG 3 FLAC').calculate_bundle
  end
end