# This file was automatically generated by the pretentious gem
require 'minitest_helper'
require "minitest/autorun"

class Digest::MD5Test < Minitest::Test
end

class Digest::MD5Scenario1 < Digest::MD5Test
  def test_current_expectation
    sample = 'This is the digest'

    # Digest::MD5::hexdigest when passed "This is the digest" should return '9f12248dcddeda976611d192efaaf72a'
    assert_equal '9f12248dcddeda976611d192efaaf72a', Digest::MD5.hexdigest(sample)
  end

end
