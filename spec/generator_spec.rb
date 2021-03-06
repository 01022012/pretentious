require 'spec_helper'

class TestSubClass
  def test_method
    "a return string"
  end
end

class TestClass
  def initialize(dep = nil)
    @test_class2 = TestSubClass.new
  end

  def message(params1)
    @params1 = params1
  end

  def method_with_assign=(params2)
    @params2 = "#{params2}!"
  end

  def method_with_usage
    @test_class2.test_method
  end
end

class DummyGenerator
  def initialize
    @data = []
  end

  def begin_spec(test_class)
    @data << {begin: test_class}
  end

  def body(instances)
    instances.each_with_index do |instance, num|
      generate(instance, num + 1)
    end
  end

  def generate(test_instance, instance_count)
    @data << {instance: test_instance.class.to_s,
              instance_method_calls: test_instance.method_calls,
              instance_count: instance_count}
  end

  def end_spec
    @data << :end
  end

  def output
    @data
  end
end

class DummyGenerator2
  def initialize
    @data = []
  end

  def begin_spec(test_class)
    @data << { begin: test_class }
  end

  def body(instances)
    instances.each_with_index do |instance, num|
      generate(instance, num + 1)
    end
  end

  def generate(test_instance, instance_count)
    @data << {generate: test_instance.class.to_s, instance_count: instance_count}

    deconstructor = Pretentious::Deconstructor.new

    deconstruct_targets = [test_instance]
    test_instance.method_calls.each do |method_calls|
      deconstruct_targets += method_calls[:params]
    end

    deconstruct = deconstructor.deconstruct(test_instance.method_calls, *deconstruct_targets)
    deconstruct[:declaration].each do |d|
      @data << d
    end

    test_instance.method_calls.each do |method_calls|
      @data << method_calls
    end
    @data << :generate_end
  end

  def end_spec
    @data << :end
  end

  def output
    @data
  end
end

RSpec.describe Pretentious::Generator do
  context 'Pretentious::Generator#impostor_for' do
    before do
      @impostor = Pretentious::Generator.impostor_for(Object, TestClass)
    end

    it "should be a class" do
      expect(@impostor.kind_of? Class).to be
    end

    it "subject class should be valid" do
      expect(@impostor.test_class).to eq TestClass
    end

    it 'show contain the same methods' do
      expect(@impostor.instance_methods).to include :message
      expect(@impostor.instance_methods).to include :method_with_assign=
    end
  end

  context "Pretentious::Generator#replace_class" do
    around(:each) do |example|
      @old_class = TestClass
      module_space, klass, last, new_class = Pretentious::Generator.replace_class(TestClass)
      @new_class = new_class
      example.run
      Pretentious::Generator.restore_class(module_space, klass, last)
    end

    it "new class should be named like the old class" do
      expect(@new_class.to_s).to eq "TestClassImpostor"
      expect(TestClass == @new_class).to be
    end

    it "a new kind of class should be created" do
      expect(@old_class == @new_class).to_not be
    end

    it "should set instance variables like the real thing" do
      instance = @new_class.new
      instance.message("hello")
      expect(instance.instance_variable_get(:@params1)).to eq "hello"
      instance.method_with_assign="world"
      expect(instance.instance_variable_get(:@params2)).to eq "world!"
    end
  end

  context "Pretentious::Generator#generate_for" do
    around(:each) do |example|
      Pretentious::Generator.test_generator = DummyGenerator
      example.run
      Pretentious::Generator.test_generator = nil
    end

    it "generates call artifacts for target class" do
      call_artifacts = Pretentious::Generator.generate_for(TestClass) do
        instance = TestClass.new
        instance.message('hello')
      end

      expect(call_artifacts).to eq(TestClass => { output:
                                        [{ begin: TestClass },
                                         { instance: 'TestClassImpostor',
                                           instance_method_calls:
                                              [{ method: :message,
                                                 params: ["hello"],
                                                 block: nil,
                                                 names: [[:req, :params1]],
                                                 context: {calls: []}, result: 'hello'}],
                                           instance_count: 1}, :end], generator: DummyGenerator})
    end

    context "auto mocks generator" do
      it "generates a stub call structure" do

        call_artifacts = Pretentious::Generator.generate_for(TestClass._stub(TestSubClass)) do
          instance = TestClass.new
          instance.method_with_usage
        end

        expect(call_artifacts).to eq({ TestClass => {output: [{:begin=>TestClass},
                                                     {:instance=>"TestClassImpostor",
                                                      :instance_method_calls=>[{:method=>:method_with_usage,
                                                      :params=>[], :block=>nil, :names=>[],
                                                      :context=>{:calls=>[{:method=>:test_method, :params=>[],
                                                      :block=>nil, :names=>[], :result=>"a return string",
                                                      :class=>TestSubClass}]}, :result=>"a return string"}],
                                                      :instance_count=>1}, :end], generator: DummyGenerator}})
      end


    end
  end

  context "reference optimization" do

    around(:each) do |example|
      Pretentious::Generator.test_generator= DummyGenerator2
      example.run
      Pretentious::Generator.test_generator= nil
    end

    it "inlines strings when possible" do
      message = nil
      object = nil
      call_artifacts = Pretentious::Generator.generate_for(TestClass1) do
        message = "test"
        object = TestClass1.new(message)
        object.message
      end

      expect(call_artifacts[TestClass1]).to eq({output: [
                                       {begin: TestClass1},
                                       {
                                         :generate => "TestClass1Impostor",
                                         :instance_count => 1
                                       },
                                       {
                                         :id => message.object_id,
                                         :class => String,
                                         :value => "test",
                                         :used_by => :inline
                                       },
                                      {
                                               :id => object.object_id,
                                               :class => TestClass1,
                                               :params_types => [[:req, :message]],
                                               :used_by => [],
                                               :ref => [ {id: message.object_id, class: String, value: "test", used_by: :inline}]

                                       },
                                      {
                                              :method => :message,
                                              :params => [],
                                              :block => nil,
                                              :names => [],
                                              :context => {
                                                  :calls => []
                                              },
                                              :result => "test"
                                      },
                                     :generate_end, :end],
                                     generator: DummyGenerator2})

    end

  end
end
