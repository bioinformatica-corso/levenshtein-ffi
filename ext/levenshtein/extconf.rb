require 'mkmf'
$defs.push("-m64 -std=c11 -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes -g -Wall -O3 -march=native -Wno-deprecated -Wno-parentheses -Wno-format")
create_makefile('levenshtein')
