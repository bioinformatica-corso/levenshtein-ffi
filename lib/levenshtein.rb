require 'ffi'
require 'minitest/spec'
require 'minitest/autorun'
require 'shoulda'

module Levenshtein
  class << self
    extend FFI::Library

    # Try loading in order.
    library = File.dirname(__FILE__) + "/../ext/levenshtein/levenshtein"
    candidates = ['.bundle', '.so', '.dylib', ''].map { |ext| library + ext }
    ffi_lib(candidates)

    # Safe version of distance, checks that arguments are really strings.
    def distance(str1, str2)
      validate(str1)
      validate(str2)
      ffi_distance(str1, str2)
    end

    # Unsafe version. Results in a segmentation fault if passed nils!
    # IMPORTANT
    # This provides a new function ffi_distance in ruby, which calls a
    # function called levenshtein from the shared library
    attach_function :ffi_distance, :levenshtein, [:string, :string], :int

    private
    def validate(arg)
      unless arg.kind_of?(String)
        raise TypeError, "wrong argument type #{arg.class} (expected String)"
      end
    end
  end
end

class LevTest < Minitest::Test
  def assert_edit(s1, s2, dist)
    assert_equal(Levenshtein::distance(s1, s2), dist)
  end

  def test_all
    assert_edit('PANNA', 'PANNA', 0)
    assert_edit('A', 'A', 0)
    assert_edit('NA', 'NN', 1)
    assert_edit('AN', 'NN', 1)
    assert_edit('BANANA', 'PANNA', 2)
  end
end
