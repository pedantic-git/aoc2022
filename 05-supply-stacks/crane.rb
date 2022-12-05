#!/usr/bin/env ruby

# Given a drawing of crates, create a hash of stacks
def stacks(drawing)
  lines = drawing.lines.reverse
  {}.tap do |s|
    # vivify the hash based on the first line (crate indexes)
    # this code assumes they are in numerical order 1-indexed, but is easily changed
    # to any arbitrary set of keys by remembering the order
    lines.shift.scan(/\d/).each { s[_1.to_i] = [] }
    # Now push each crate onto the newly generated stack, line by line
    lines.each do |line|
      # \s could be a space or the \n at the end
      line.scan(/.(.).\s/).each.with_index do |crate, i|
        s[i+1] << $1 unless $1 == ' '
      end
    end
  end
end

