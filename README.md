[![Gem Version](https://badge.fury.io/rb/pretentious.svg)](https://badge.fury.io/rb/pretentious)

# Ruby::Pretentious

Do you have a pretentious boss or development lead that pushes you to embrace BDD/TDD but for reasons hate it or them?
here is a gem to deal with that. Now you CAN write your code first and then GENERATE tests later!! Yes you heard that
right! To repeat, this gem allows you to write your code first and then automatically generate tests using the code
you've written in a straightfoward manner!

On a serious note, this gem allows you to generate tests template much better than those generated by default
for various frameworks. It is also useful for "recording" current behavior of existing components in order
to prepare for refactoring. As a bonus it also exposes an Object Deconstructor which allows you, given
any object, to obtain a ruby code on how it was created.


## Table of Contents

1.  [Installation](#installation)
2.  [Usage](#usage)
3.  [Handling complex parameters and object constructors](#handling-complex-parameters-and-object-constructors)
4.  [Capturing Exceptions](#capturing-exceptions)
5.  [Object Deconstruction Utility](#object-deconstruction-utility)
    1.  [Using the Object deconstructor in rails](#using-the-object-deconstructor-in-rails)
6.  [Things to do after](#things-to-do-after)
7.  [Limitations](#limitations)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pretentious'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pretentious

## Usage

First Create an example file (etc. example.rb) and define the classes that you want to test, if the class is
already defined elsewhere just require them. Below is an example:

```ruby
class Fibonacci

  def fib(n)
    return 0 if (n == 0)
    return 1 if (n == 1)
    return 1 if (n == 2)
    return fib(n - 1) + fib(n - 2)
  end

  def self.say_hello
    "hello"
  end

end
```

Inside a Pretentious.spec_for(...) block. Just write boring code that instantiates an object as well as calls the methods
like how you'd normally use them. Finally Specify the classes that you want to test:

```ruby
class Fibonacci

  def fib(n)
    return 0 if (n == 0)
    return 1 if (n == 1)
    return 1 if (n == 2)
    return fib(n - 1) + fib(n - 2)
  end

  def self.say_hello
    "hello"
  end

end

Pretentious.spec_for(Fibonacci) do


  instance = Fibonacci.new

  (1..10).each do |n|
    instance.fib(n)
  end

  Fibonacci.say_hello

end
```

Save your file and then switch to the terminal to invoke:

    $ ddtgen example.rb

This will automatically generate rspec tests for Fibonacci under /spec of the current working directory.

You can actually invoke rspec at this point, but the tests will fail. Before you do that you should edit
spec/spec_helper.rb and put the necessary requires and definitions there.

For this example place the following into spec_helper.rb:

```ruby
#inside spec_helper.rb
class Fibonacci

  def fib(n)
    return 0 if (n == 0)
    return 1 if (n == 1)
    return 1 if (n == 2)
    return fib(n - 1) + fib(n - 2)
  end

  def self.say_hello
    "hello"
  end

end
```

The generated spec file should look something like this

```ruby
require 'spec_helper'

RSpec.describe Fibonacci do

  context 'Scenario 1' do
    before do


      @fixture = Fibonacci.new

    end

    it 'should pass current expectations' do

      n = 1
      n_1 = 2
      n_2 = 3
      n_3 = 4
      n_4 = 5

      # Fibonacci#fib when passed n = 1 should return 1
      expect( @fixture.fib(n) ).to eq(1)

      # Fibonacci#fib when passed n = 2 should return 1
      expect( @fixture.fib(n_1) ).to eq(1)

      # Fibonacci#fib when passed n = 3 should return 2
      expect( @fixture.fib(n_2) ).to eq(2)

      # Fibonacci#fib when passed n = 4 should return 3
      expect( @fixture.fib(n_3) ).to eq(3)

      # Fibonacci#fib when passed n = 5 should return 5
      expect( @fixture.fib(n_4) ).to eq(5)

    end
  end

    it 'should pass current expectations' do


      # Fibonacci::say_hello when passed  should return hello
      expect( Fibonacci.say_hello ).to eq("hello")

    end
end
```

awesome!

You can also try this out with built-in libraries like MD5 for example ...

```ruby
#example.rb

Pretentious.spec_for(Digest::MD5) do
  sample = "This is the digest"
  Digest::MD5.hexdigest(sample)
end
```

You should get something like:

```ruby
require 'spec_helper'

RSpec.describe Digest::MD5 do

    it 'should pass current expectations' do

      sample = "This is the digest"

      # Digest::MD5::hexdigest when passed "This is the digest" should return 9f12248dcddeda976611d192efaaf72a
      expect( Digest::MD5.hexdigest(sample) ).to eq("9f12248dcddeda976611d192efaaf72a")

    end
end
```

Only RSpec is supported at this point. But other testing frameworks should be trivial to add support to.

## Handling complex parameters and object constructors

No need to do anything special, just do as what you would do normally and the pretentious gem will figure it out.
see below for an example:

```ruby
    class TestClass1

      def initialize(message)
        @message = message
      end

      def print_message
        puts @message
      end

      def something_is_wrong
        raise StandardError.new
      end
    end

    class TestClass2
      def initialize(message)
        @message = {message: message}
      end

      def print_message
        puts @message[:message]
      end
    end

    class TestClass3

      def initialize(testclass1, testclass2)
        @class1 = testclass1
        @class2 = testclass2
      end

      def show_messages
        @class1.print_message
        @class2.print_message
        "awesome!!!"
      end

    end
```

We then instantiate the class using all sorts of weird parameters:

```ruby
  Pretentious.spec_for(TestClass3) do
      another_object = TestClass1.new("test")
      test_class_one = TestClass1.new({hello: "world", test: another_object, arr_1: [1,2,3,4,5, another_object],
                                      sub_hash: {yes: true, obj: another_object}})
      test_class_two = TestClass2.new("This is message 2")

      class_to_test = TestClass3.new(test_class_one, test_class_two)
      class_to_test.show_messages
  end
```

Creating tests for TestClass3 should yield

```ruby
RSpec.describe TestClass3 do

  context 'Scenario 1' do
    before do

      var_2167529620 = "test"
      another_object = TestClass1.new(var_2167529620)
      args = {hello: "world", test: another_object, arr_1: [1, 2, 3, 4, 5, another_object], sub_hash: {yes: true, obj: another_object}}
      test_class_one = TestClass1.new(args)
      args_1 = "This is message 2"
      test_class_two = TestClass2.new(args_1)

      @fixture = TestClass3.new(test_class_one, test_class_two)

    end

    it 'should pass current expectations' do


      # TestClass3#show_messages when passed  should return awesome!!!
      expect( @fixture.show_messages ).to eq("awesome!!!")

    end
  end
```

Note that creating another instance of TestClass3 will result in the creation of another Scenario

## Capturing Exceptions

Exceptions thrown by method calls should generate the appropriate exception test case. Just make sure
that you rescue inside your example file like below:

```ruby
  begin
    test_class_one.something_is_wrong
  rescue Exception=>e
  end
```

should generate the following in rspec

```ruby
  # TestClass1#something_is_wrong when passed  should return StandardError
  expect { @fixture.something_is_wrong }.to raise_error
```
## Object Deconstruction Utility

As Pretentious as the gem is, there are other uses other than generating tests specs. Tools are also available to
deconstruct objects. Object deconstruction basically means that the components used to create and initialize an object
are extracted and decomposed until only primitive types remain. The pretentious gem will also generate the
necessary ruby code to create one from scratch. Below is an example:

Given an instance of an activerecord base connection for example

```ruby
ActiveRecord::Base.connection
```

running deconstruct would generate:

```ruby
var_70301267513280 = #<File:0x007fe094279f80>
logger = ActiveSupport::Logger.new(var_70301267513280)
connection_options = ["localhost", "root", "password", "test_db", nil, nil, 131074]
config = {adapter: "mysql", encoding: "utf8", reconnect: false, database: "test_db", pool: 5, username: "root", password: "password", host: "localhost"}
var_70301281665660 = ActiveRecord::ConnectionAdapters::MysqlAdapter.new(connection, logger, connection_options, config)
```
Note that

```ruby
var_70301267513280 = #<File:0x007fe094279f80>
```

because the pretentious gem was not able to capture its init arguments.

## How to use

Simply call:

    Pretentious.install_watcher

before all your objects are initalized. This will add the following methods to all objects:

```ruby
object._deconstruct
object._deconstruct_to_ruby
```
The _deconstruct method generates a raw deconstruction data structure used by the _deconstruct_to_ruby method.

Of course _deconstruct_to_ruby generates the ruby code necessary to create the object!

## Using the Object deconstructor in rails

In your Gemfile, add the pretentious gem.

```ruby
group :test do
  gem 'pretentious'
end
```

The do a bundle

    $ bundle


Note: It is advisable to add it only in the test or development group!
The way it logs objects would probably prevent anything from being GC'ed.

For rails, including inside config.ru is sufficient to capture most objects:

```ruby
#config.ru
require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if Rails.env.test?
  puts "watching new instances"
  Pretentious::Generator.watch_new_instances
end

module App
  class Application < Rails::Application
    # ..... stuf ......

  end
end
```

boot up the rails console and blow your mind:

```
$ rails c -e test
watching new instances
Loading test environment (Rails 4.2.4)
irb: warn: can't alias context from irb_context.
2.2.0 :001 > puts ActiveRecord::Base.connection._deconstruct_to_ruby
connection = #<Mysql:0x007fe095d785c0>
var_70301267513280 = #<File:0x007fe094279f80>
logger = ActiveSupport::Logger.new(var_70301267513280)
connection_options = ["localhost", "root", "password", "app_test", nil, nil, 131074]
config = {adapter: "mysql", encoding: "utf8", reconnect: false, database: "app_test", pool: 5, username: "root", password: "password", host: "localhost"}
var_70301281665660 = ActiveRecord::ConnectionAdapters::MysqlAdapter.new(connection, logger, connection_options, config)
 => nil
2.2.0 :004 > w = User.where(id: 1)
User Load (2.8ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = ?  [["id", 1]]
=> #<ActiveRecord::Relation []>
2.2.0 :005 > w._deconstruct_to_ruby
=> "klass = User\nvar_70301317929300 = \"users\"\ntable = Arel::Table.new(var_70301317929300, klass)\nvar_70301339518120 = User::ActiveRecord_Relation.new(klass, table)\n"
2.2.0 :006 > puts w._deconstruct_to_ruby
klass = User
var_70301317929300 = "users"
table = Arel::Table.new(var_70301317929300, klass)
var_70301339518120 = User::ActiveRecord_Relation.new(klass, table)
=> nil
2.2.0 :007 >
```

Note: There are some objects it will fails to capture and as such those would not deconstruct properly.


## Things to do after

Since your tests are already written, and hopefully nobody notices its written by a machine, you may just leave it
at that. Take note of the limitations though.

But if lest your conscience suffers, it is best to go back to the specs and refine them, add more tests and behave like
a bdd'er/tdd'er.

## Limitations

Computers are bad at mind reading (for now) and they don't really know your expectation of "correctness", as such
it assumes your code is correct and can only use equality based matchers. It can also only reliably match
primitive data types, hashes, Procs and arrays to a degree. More complex expectations are unfortunately left for the humans
to resolve. This is expected to improve in future versions of the pretentious gem.

Procs that return a constant value will be resolved properly. However variable return values are currently still
not generated properly will return a stub (future versions may use sourcify to resolve Procs for ruby 1.9)

Also do note that it tries its best to determine how your fixtures are created, as well as the types
of your parameters and does so by figuring out (recursively) the components that your object needs. Failure can happen during this process.

Finally, Limit this gem for test environments only.

## Bugs

This is the first iteration and a lot of broken things could happen

## Contributing

1. Fork it (https://github.com/jedld/pretentious.git)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
