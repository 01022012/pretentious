#!/bin/sh

git add .
gem build pretentious.gemspec
gem install pretentious-0.1.10.gem
ruby test/test_generator.rb
