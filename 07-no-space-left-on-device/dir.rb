#!/usr/bin/env ruby

module NSLOD

  Dir = Struct.new(:name, :parent, :contents, keyword_init: true) do
    include Enumerable

    def initialize(*)
      super
      self.contents ||= []
    end

    # Get the size of this directory, recursively
    def size
      @size ||= contents.sum(&:size)
    end

    # Recursive - directories only (for now)
    def each(&block)
      block.call self
      contents.each {_1.kind_of?(Dir) && _1.each(&block)}
    end

    def <=>(other)
      size <=> other.size
    end
  end

  File = Struct.new(:name, :size, keyword_init: true)

  class Shell
    attr_reader :root, :input
    attr_accessor :pwd

    DISK_SIZE = 70_000_000

    # input should be an IO
    def initialize(input)
      @input = input
      @pwd = @root = Dir.new(name: '/')
      run!
    end

    def free_space
      DISK_SIZE - root.size
    end

    def cd(dir)
      case dir
      when "/"
        self.pwd = self.root
      when ".."
        self.pwd = pwd.parent
      else
        self.pwd = pwd.contents.find {_1.name == dir} || mkdir(dir)
      end
    end

    def ls
      loop do
        case entry = input.readline
        when /\A\$/
          # it's a command - seek back and break
          input.seek(-entry.length, IO::SEEK_CUR)
          break
        when /dir (\S+)/
          mkdir($1)
        when /(\d+) (\S+)/
          pwd.contents.push File.new(size: $1.to_i, name: $2)
        else
          raise "Unexpected listing entry: #{entry}"
        end
      end
    end

    private

    def run!
      loop do
        case cmd = input.readline
        when /\A\$ cd (\S+)/
          cd($1)
        when /\A\$ ls/
          ls
        else
          raise "Unexpected input: #{cmd}"
        end
      end
    rescue EOFError
      # Done!
    end

    def mkdir(name)
      Dir.new(name: name, parent: pwd).tap do |dir|
        pwd.contents.push dir
      end
    end
  end
end

s = NSLOD::Shell.new($<)

# Part 1
small_dirs = s.root.find_all {|d| d.size <= 100000}
puts "Total size of small dirs: #{small_dirs.sum(&:size)}"

# Part 2
puts "Free space is: #{s.free_space}"
needed_space = 30_000_000 - s.free_space
puts "So we need to delete: #{needed_space}"
smallest_dir = s.root.find_all {|d| d.size >= needed_space}.min
puts "Smallest dir we can delete is #{smallest_dir.name} with a size of #{smallest_dir.size}"
