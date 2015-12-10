# This file was automatically generated by the pretentious gem
require 'spec_helper'

RSpec.describe TestClass2 do
  context 'Scenario 1' do
    before do
      @fixture = TestClass2.new('This is message 2', nil)
    end

    it 'should pass current expectations' do
      # TestClass2#print_message  should return nil
      expect(@fixture.print_message).to be_nil
    end
  end

  context 'Scenario 2' do
    before do
      @fixture = TestClass2.new('This is message 3', nil)
    end

    it 'should pass current expectations' do
    end
  end

  context 'Scenario 3' do
    before do
      @message2 = 'This is message 3'
      message = TestClass2.new(@message2, nil)
      @fixture = TestClass2.new(message, @message2)
    end

    it 'should pass current expectations' do
      # TestClass2#test when passed object = "This is message 3" should return 'This is message 3'
      expect(@fixture.test(@message2)).to eq('This is message 3')
    end
  end

end
