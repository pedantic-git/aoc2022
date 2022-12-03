#!/usr/bin/env ruby

# Get the priority for a given item
def priority(item)
  (item.ord - 96) % 58 # 58 is the number of positions back in ASCII that A appears before z
end

# Given three rucksack strings, find the priority of the item they have in common
def common(three_rucksacks)
  priority three_rucksacks.map {_1.chomp.split('')}.reduce(:&).first
end

p $<.readlines.each_slice(3).sum(&method(:common))
