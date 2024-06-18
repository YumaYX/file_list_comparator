#!/usr/bin/env ruby
# frozen_string_literal: true

def flist_to_h(cksum_file_name, prefix = '')
  hash = {}
  
  File.foreach(cksum_file_name) do |line|
    line.chomp!
    parts = line.match(/^(\d+)\s+\d+\s+(.*)$/)
    sum_value = parts[1].to_i
    file_name = prefix + parts[2].gsub(%r{^\./}, '')
    hash[file_name] = sum_value
  end
  
  hash
end

# change?
def extract_change(list_a, list_b)
  diff = []
  list_b.each do |target_file_name, fsum|
    diff << target_file_name if list_a.key?(target_file_name) && fsum != list_a[target_file_name]
  end
  diff
end

# add?
def add_list(list_a, list_b)
  list_b.keys - list_a.keys
end

if __FILE__ == $PROGRAM_NAME
  a = flist_to_h(ARGV.first) # old
  b = flist_to_h(ARGV.last) # new

  ec = extract_change(a, b)
  puts 'CHANGE:'
  ec.each do |ele|
    puts ele
  end

  puts 'ADD:'
  al = add_list(a, b)
  al.each do |ele|
    puts ele
  end

  puts 'DELETE:'
  dl = add_list(b, a)
  dl.each do |ele|
    puts ele
  end
end
