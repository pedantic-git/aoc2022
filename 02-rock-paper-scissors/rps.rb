#!/usr/bin/env ruby

# Solves part 1

def score(round)
  {'X' => 1, 'Y' => 2, 'Z' => 3}[round[1]] +
  case round
  when %w[A X], %w[B Y], %w[C Z]
    3
  when %w[A Y], %w[B Z], %w[C X]
    6
  else
    0
  end
end

rounds = $<.readlines.map(&:split)

total = rounds.inject(0) {|acc,round| acc + score(round)}
p total
