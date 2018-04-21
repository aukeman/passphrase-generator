#!/usr/bin/env ruby

require 'set'

if ARGV.length < 3
  STDERR.puts <<EOF
USAGE: #{File.basename $0} <words list> <phonemes> <frequency>
EOF
  exit 1
end

dictionary=ARGV[0]
phonemes=ARGV[1]
frequency=ARGV[2]

def count_syllables(phonemes_list)
  phonemes_list.count {|p| p =~ /^[aeiou]/}
end

words=File
       .readlines(dictionary)
       .map(&:chomp)
       .to_set

STDERR.puts 'read words list...'

syllables_db=File.open(phonemes, 'rb') do |f|
  f.readlines
    .select {|line| line =~ /^[A-Z]+\s/}
    .map {|line| line.downcase.split}
    .select {|word, *_| words.include?(word)}
    .reduce({}) {|a, e| a.merge(e[0] => count_syllables(e[1..-1]))}
end

STDERR.puts 'compiled syllables db...'

frequency_db=File
              .readlines(frequency)
              .map{|line| line.split}
              .select{|word, _| words.include?(word)}
              .select{|word, _| syllables_db.has_key?(word)}
              .map{|word, freq| [word, freq.chomp.to_i]}
              .sort_by{|word_and_freq| -word_and_freq[1]}
              .map{|word, _| word}
              .map.with_index(1)
              .reduce({}) {|a, e| a.merge(e[0] => e[1])}

STDERR.puts 'compiled frequency db...'

data=words
       .select{|w| frequency_db.has_key?(w) }
       .select{|w| syllables_db.has_key?(w) }
       .map{|w| [w, w.length, syllables_db[w], frequency_db[w]] }

STDERR.puts 'compiled database...'


min_length=data.min_by{|d| d[1]}[1]
max_length=data.max_by{|d| d[1]}[1]

min_syllables=data.min_by{|d| d[2]}[2]
max_syllables=data.max_by{|d| d[2]}[2]

min_frequency=data.min_by{|d| d[3]}[3]
max_frequency=data.max_by{|d| d[3]}[3]

puts "#{min_length} #{min_syllables} #{min_frequency}"
puts "#{max_length} #{max_syllables} #{max_frequency}"
puts data.map {|d| d.join(' ')}

