#!/usr/bin/env ruby

elves = $<.readlines.chunk {|l| /\d/ =~ l || :_separator}
calories = elves.map {|_, elf| elf.sum(&:to_i)}

puts "Max calories: #{calories.max}"


