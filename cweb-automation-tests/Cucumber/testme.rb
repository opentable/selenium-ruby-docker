require 'rubygems'
gem 'minitest', :version=>'5.8.5'
require 'minitest/autorun'

class Testme < Minitest::Test

  def somename
    assert(1.nil?, "This should not be printed")
    assert_equal 1, 1, "This too should not be printed"
  end

end