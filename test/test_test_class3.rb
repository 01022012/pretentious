#This file was automatically generated by the pretentious gem
require 'minitest_helper'
require "minitest/autorun"

class TestTestClass3 < Minitest::Test
end

class Scenario1 < TestTestClass3
  def setup
    var_2175164340 = "test"
    another_object = TestClass1.new(var_2175164340)
    args = {hello: "world", test: another_object, arr_1: [1, 2, 3, 4, 5, another_object], sub_hash: {yes: true, obj: another_object}}
    test_class_one = TestClass1.new(args)
    args_1 = "This is message 2"
    test_class_two = TestClass2.new(args_1)

    @fixture = TestClass3.new(test_class_one, test_class_two)
  end

  def test_current_expectation

    #TestClass3#show_messages  should return awesome!!!
    assert_equal "awesome!!!", @fixture.show_messages


  end
end

class Scenario2 < TestTestClass3
  def setup
    var_2175164340 = "test"
    another_object = TestClass1.new(var_2175164340)
    args = {hello: "world", test: another_object, arr_1: [1, 2, 3, 4, 5, another_object], sub_hash: {yes: true, obj: another_object}}
    test_class_one = TestClass1.new(args)
    args_1 = "This is message 2"
    test_class_two = TestClass2.new(args_1)

    @fixture = TestClass3.new(test_class_one, test_class_two)
  end

  def test_current_expectation

    #TestClass3#show_messages  should return awesome!!!
    assert_equal "awesome!!!", @fixture.show_messages


  end
end
