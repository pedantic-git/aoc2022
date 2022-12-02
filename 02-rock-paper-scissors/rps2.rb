#!/usr/bin/env ruby

# Solves part 2

# Could have been clever about this, but there are only 9 possible rounds and so
# unrolling it is just fine as a solution
scores = {
  %w[A X] => 3,
  %w[B X] => 1,
  %w[C X] => 2,
  %w[A Y] => 4,
  %w[B Y] => 5,
  %w[C Y] => 6,
  %w[A Z] => 8,
  %w[B Z] => 9,
  %w[C Z] => 7
}

rounds = $<.readlines.map(&:split)
total = rounds.sum { |round| scores[round] }

p total
