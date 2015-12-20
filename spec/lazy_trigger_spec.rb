require 'spec_helper'

RSpec.describe Pretentious::LazyTrigger do
  it 'Can predeclare even if the class is not yet defined' do
    Pretentious.watch do
      lazy_trigger = Pretentious::LazyTrigger.new('TestLazyClass')

      class TestLazyClass
        def test_method
        end
      end

      lazy_class = TestLazyClass.new
      lazy_class.test_method

      expect(lazy_trigger.targets.keys).to eq([Object.const_get('TestLazyClass')])
      expect(Pretentious::LazyTrigger.collect_artifacts).to eq([Object.const_get('TestLazyClass')])
      expect(TestLazyClass._instances).to eq([lazy_class])
      lazy_trigger.disable!
    end
  end

  it "can use strings in spec_for to use the lazy trigger" do
    call_artifacts = Pretentious::Generator.generate_for("TestLazyClass2") do
      class TestLazyClass2
        def test_method
        end
      end

      lazy_class = TestLazyClass2.new
      lazy_class.test_method
    end
    expect(call_artifacts).to eq({TestLazyClass2=>{:output=>"# This file was automatically generated by the pretentious gem\nrequire 'spec_helper'\n\nRSpec.describe TestLazyClass2 do\n  context 'Scenario 1' do\n    before do\n      @fixture = TestLazyClass2.new\n    end\n\n    it 'should pass current expectations' do\n      # TestLazyClass2#test_method  should return nil\n      expect(@fixture.test_method).to be_nil\n    end\n  end\nend", :generator=>Pretentious::RspecGenerator}})
  end

  it "can use regex to perform a match on the class name" do
    call_artifacts = Pretentious::Generator.generate_for(/^TestLazyClassR/) do
      class TestLazyClassR1
        def test_method
        end
      end

      class TestLazyClassR2
        def test_method
        end
      end

      lazy_class1 = TestLazyClassR1.new
      lazy_class1.test_method

      lazy_class2 = TestLazyClassR2.new
      lazy_class2.test_method
    end

    expect(call_artifacts).to eq({ TestLazyClassR1 => { :output => "# This file was automatically generated by the pretentious gem\nrequire 'spec_helper'\n\nRSpec.describe TestLazyClassR1 do\n  context 'Scenario 1' do\n    before do\n      @fixture = TestLazyClassR1.new\n    end\n\n    it 'should pass current expectations' do\n      # TestLazyClassR1#test_method  should return nil\n      expect(@fixture.test_method).to be_nil\n    end\n  end\nend", :generator=>Pretentious::RspecGenerator}, TestLazyClassR2=>{:output=>"# This file was automatically generated by the pretentious gem\nrequire 'spec_helper'\n\nRSpec.describe TestLazyClassR2 do\n  context 'Scenario 1' do\n    before do\n      @fixture = TestLazyClassR2.new\n    end\n\n    it 'should pass current expectations' do\n      # TestLazyClassR2#test_method  should return nil\n      expect(@fixture.test_method).to be_nil\n    end\n  end\nend", :generator=>Pretentious::RspecGenerator}})
  end
end
