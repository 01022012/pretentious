#This file was automatically generated by the pretentious gem
require 'minitest_helper'
require "minitest/autorun"

class TestTestClassForMocks < Minitest::Test
end

class TestClassForMocksScenario1 < TestTestClassForMocks
  def setup
    @fixture = TestClassForMocks.new
  end

  def test_current_expectation
    var_2174075580 = [2, 3, 4, 5]

    TestMockSubClass.stub_any_instance(:test_method, "a return string") do
      TestMockSubClass.stub_any_instance(:increment_val, 2) do
        #TestClassForMocks#method_with_assign= when passed params2 = "test" should return test
        assert_equal "test", @fixture.method_with_assign=("test")

        #TestClassForMocks#method_with_usage  should return a return string
        assert_equal "a return string", @fixture.method_with_usage

        #TestClassForMocks#method_with_usage2  should return [2, 3, 4, 5]
        assert_equal [2, 3, 4, 5], @fixture.method_with_usage2

        #TestClassForMocks#method_with_usage4  should return a return string
        assert_equal "a return string", @fixture.method_with_usage4

      end
    end

  end
end

class TestClassForMocksScenario2 < TestTestClassForMocks
  def setup
    @fixture = TestClassForMocks.new
  end

  def test_current_expectation
    var_2167328180 = {val: 1, str: "hello world", message: "a message"}

    TestMockSubClass.stub_any_instance(:return_hash, var_2167328180) do
      #TestClassForMocks#method_with_usage3 when passed message = "a message" should return {:val=>1, :str=>"hello world", :message=>"a message"}
      assert_equal var_2167328180, @fixture.method_with_usage3("a message")

    end

  end
end

