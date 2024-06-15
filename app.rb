#!/usr/bin/env ruby
# frozen_string_literal: true

def flist_to_h(cksum_file_name)
  hash = {}
  lines = File.readlines(cksum_file_name).map(&:chomp)
  lines.map do |line|
    parts = line.match(/^(\d+)\s+\d+\s+(.*)$/)
    sum_value = parts[1].to_i
    file_name = parts[2]
    hash[file_name] = sum_value
  end
  hash
end

# change?
def extract_change(list_a, list_b, prefix = '')
  diff = []

  list_b.each do |target_file_name, fsum|
    target_file_name = prefix + target_file_name

    diff << target_file_name if list_a.key?(target_file_name) && fsum != list_a[target_file_name]
  end
  diff
end

# del?
def delete_list(list_a, list_b, _prefix = '')
  a_keys = list_a.keys
  b_keys = list_b.keys
  b_keys - a_keys
end

if __FILE__ == $PROGRAM_NAME
  a = flist_to_h(ARGV.first)
  b = flist_to_h(ARGV.last)

  ec = extract_change(a, b)
  p ec

  dl = delete_list(a, b)
  p dl
end
