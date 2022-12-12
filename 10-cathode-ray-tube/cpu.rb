#!/usr/bin/env ruby

class Cpu
  attr_accessor :cycle, :x, :signal_sum

  def initialize
    self.cycle = 0
    self.x = 1
    self.signal_sum = 0
  end

  def instruct!(instruction)
    method, *args = instruction.split
    send(method.to_sym, *args) if method
  end

  def signal_strength
    cycle * x
  end

  private

  def addx(n)
    2.times { tick! }
    self.x += n.to_i
  end

  def noop
    tick!
  end

  def tick!
    self.cycle += 1
    if (cycle-20)%40 == 0
      self.signal_sum += signal_strength
    end
  end
end

Cpu.new.then do |cpu|
  while inst = $<.gets do
    cpu.instruct! inst
  end
  puts "Signal sum = #{cpu.signal_sum}"
end
