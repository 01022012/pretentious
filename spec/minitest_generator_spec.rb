require 'spec_helper'

RSpec.describe Pretentious::Generator do

  context 'Pretentious::MinitestGenerator' do

    before do
      @fixture = Pretentious::Generator.new
      Pretentious::Generator.test_generator = Pretentious::MinitestGenerator
    end

    it "classes should have a stub class section" do
      Fibonacci._stub(String)
      expect(Fibonacci._get_stub_classes).to eq([String])
    end

    it "tracks object calls" do
      result = Pretentious::Generator.generate_for(Fibonacci) do
        Fibonacci.say_hello
      end
      expect(result).to eq(Fibonacci => { output: "# This file was automatically generated by the pretentious gem\nrequire 'minitest_helper'\nrequire 'minitest/autorun'\n\nclass FibonacciTest < Minitest::Test\nend\n\nclass FibonacciScenario1 < FibonacciTest\n  def test_current_expectation\n    # Fibonacci::say_hello  should return 'hello'\n    assert_equal 'hello', Fibonacci.say_hello\n  end\nend",
        generator: Pretentious::MinitestGenerator })
    end

    context "proc handling" do
      it 'handles blocks passed to methods' do
        result = Pretentious.minitest_for(TestClass1) do
          test_class = TestClass1.new('message')
          test_class.set_block do
            'a string'
          end
        end
        expect(result[TestClass1][:output]).to be < 'expect(@fixture.set_block  &c).to eq(a)'
      end
    end

    it 'Makes sure expectations are unique' do
      result = Pretentious.minitest_for(TestClass1) do
        test_class = TestClass1.new("message")
        test_class.message
        test_class.message
      end
      puts result[TestClass1][:output]
      expect(result[TestClass1][:output]
             .scan(/assert_equal\ 'message',\ @fixture\.message/).count)
             .to eq(1)
    end

    it "handles exceptions" do
      result = Pretentious.minitest_for(TestClass1) do
        test_class = TestClass1.new('message')
        begin
          test_class.something_is_wrong
        rescue StandardError => e
          puts 'something is wrong'
        end
      end

      expect(result[TestClass1][:output]).to match(/assert_raises\(StandardError\) \{ @fixture.something_is_wrong \}/)
    end

    it "handles method missing" do
      result = Pretentious.minitest_for(TestClassMethodMissing) do
        test_class = TestClassMethodMissing.new
        test_class.handled_by_method_missing
      end

      expect(result[TestClassMethodMissing][:output]).to match("YOU GOT ME!!!!")
    end
  end
end
