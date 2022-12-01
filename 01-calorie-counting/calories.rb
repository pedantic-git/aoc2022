#!/usr/bin/env ruby

elves = $<.readlines.chunk {|l| /\d/ =~ l || :_separator}
calories = elves.map {|_, elf| elf.sum(&:to_i)}

puts "Max calories: #{calories.max}"
puts "Top three total calories: #{calories.max(3).sum}"
