#!/usr/bin/env ruby

require 'pry'

class Monkey
  attr_reader :monkeys, :items, :operation, :test
  attr_accessor :count

  def initialize(monkeys, notes)
    @monkeys = monkeys
    @items = /Starting items: (.+)/.match(notes)[1].split(', ').map(&:to_i)
    @operation = create_operation(notes)
    @test = create_test(notes)
    @count = 0
  end

  def inspect_items!
    items.each do |item|
      worry = operation.call(item) / 3
      throw_to = test.call(worry)
      monkeys[throw_to].items << worry
      self.count += 1
    end
    items.replace []
  end

  private

  def create_operation(notes)
    /Operation: new = old (.) (\S+)/.match(notes)
    ->(x) { x.public_send($1.to_sym, $2 == 'old' ? x : $2.to_i) }
  end

  def create_test(notes)
    divisor = /Test: divisible by (\d+)/.match(notes)[1].to_i
    true_monkey = /If true: throw to monkey (\d+)/.match(notes)[1].to_i
    false_monkey = /If false: throw to monkey (\d+)/.match(notes)[1].to_i
    ->(x) { (x % divisor) == 0 ? true_monkey : false_monkey }
  end
end

class Monkeys < Array

  def run!
    20.times { round! }
  end

  def round!
    each(&:inspect_items!)
  end

  def monkey_business
    map(&:count).max(2).reduce(&:*)
  end
end

monkeys = Monkeys.new
$<.readlines.chunk {|l| l == "\n" ? :_separator : true }.each do |notes|
  monkeys << Monkey.new(monkeys, notes.join)
end

monkeys.run!

puts "Monkey business is: #{monkeys.monkey_business}"
