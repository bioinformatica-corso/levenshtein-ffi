require 'ffi'

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


puts "#{Levenshtein::distance('PANNA', 'PANNA')} should be 0"
puts "#{Levenshtein::distance('A', 'B')} should be 1"
puts "#{Levenshtein::distance('AA', 'AB')} should be 1"
puts "#{Levenshtein::distance('BA', 'AA')} should be 1"
puts "#{Levenshtein::distance('BANANA', 'PANNA')} should be 2"
