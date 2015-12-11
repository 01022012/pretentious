# This file was automatically generated by the pretentious gem
require 'minitest_helper'
require 'minitest/autorun'

class TestClass2Test < Minitest::Test
end

class TestClass2Scenario1 < TestClass2Test
  def setup
    @fixture = TestClass2.new('This is message 2', nil)
  end

  def test_current_expectation
    # TestClass2#print_message  should return nil
    assert_nil @fixture.print_message
    # TestClass2#print_message  should return nil
    assert_nil @fixture.print_message
  end
end

class TestClass2Scenario2 < TestClass2Test
  def setup
    @fixture = TestClass2.new('This is message 3', nil)
  end

  def test_current_expectation
  end
end

class TestClass2Scenario3 < TestClass2Test
  def setup
    @message2 = 'This is message 3'
    message = TestClass2.new(@message2, nil)
    @fixture = TestClass2.new(message, @message2)
  end

  def test_current_expectation
    # TestClass2#test when passed object = "This is message 3" should return 'This is message 3'
    assert_equal 'This is message 3', @fixture.test(@message2)
  end
end