#!/usr/bin/env ruby

require 'pp'
require 'stringio'

module NSLOD

  Dir = Struct.new(:name, :parent, :contents, keyword_init: true) do
    def initialize(*)
      super
      self.contents ||= []
    end
  end

  File = Struct.new(:name, :size, keyword_init: true)

  class Shell
    attr_reader :root, :input
    attr_accessor :pwd

    # input should be an IO
    def initialize(input)
      @input = input
      @pwd = @root = Dir.new(name: '/')
    end

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

    def mkdir(name)
      Dir.new(name: name, parent: pwd).tap do |dir|
        pwd.contents.push dir
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
  end
end

input = StringIO.new(<<~EOT)
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
EOT

s = NSLOD::Shell.new(input)
s.run!
pp s.root
