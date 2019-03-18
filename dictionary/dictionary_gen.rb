#!/usr/bin/env ruby

require 'set'

dictionary=File.join(File.dirname(__FILE__), 'words.txt')
phonemes=File.join(File.dirname(__FILE__), 'phonemes.txt')
frequency=File.join(File.dirname(__FILE__), 'frequency.txt')
nouns=File.join(File.dirname(__FILE__), 'nouns.txt')
verbs=File.join(File.dirname(__FILE__), 'verbs.txt')
adjectives=File.join(File.dirname(__FILE__), 'adjectives.txt')
adverbs=File.join(File.dirname(__FILE__), 'adverbs.txt')

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

nouns_db=File
          .readlines(nouns)
          .map(&:chomp)
          .select{|word| words.include?(word)}
          .select{|word| syllables_db.has_key?(word)}
          .to_set

STDERR.puts 'compiled nouns db...'

verbs_db=File
          .readlines(verbs)
          .map(&:chomp)
          .select{|word| words.include?(word)}
          .select{|word| syllables_db.has_key?(word)}
          .to_set

STDERR.puts 'compiled verbs db...'

adjectives_db=File
               .readlines(adjectives)
               .map(&:chomp)
               .select{|word| words.include?(word)}
               .select{|word| syllables_db.has_key?(word)}
               .to_set

STDERR.puts 'compiled adjectives db...'

adverbs_db=File
          .readlines(adverbs)
          .map(&:chomp)
          .select{|word| words.include?(word)}
          .select{|word| syllables_db.has_key?(word)}
          .to_set

STDERR.puts 'compiled adverbs db...'

def is_adjective? w, db
  (db.include?(w) ||
   db.include?(w.sub(/ier$/, 'y')) ||
   db.include?(w.sub(/iest$/, 'y')))
end

def is_noun? w, db
  (db.include?(w) ||
   db.include?(w.sub(/s$/, '')) ||
   db.include?(w.sub(/es$/, '')) ||
   db.include?(w.sub(/ies$/,'y')) ||
   db.include?(w.sub(/men$/,'man')) ||
   db.include?(w.sub(/ves$/,'f')))
end

def is_verb? w, db
  (db.include?(w) ||
   db.include?(w.sub(/s$/, '')) ||
   db.include?(w.sub(/es$/, '')) ||
   db.include?(w.sub(/ing$/,'')) ||
   db.include?(w.sub(/bbing$/,'b')) ||
   db.include?(w.sub(/dding$/,'d')) ||
   db.include?(w.sub(/gging$/,'g')) ||
   db.include?(w.sub(/lling$/,'l')) ||
   db.include?(w.sub(/mming$/,'m')) ||
   db.include?(w.sub(/nning$/,'n')) ||
   db.include?(w.sub(/pping$/,'p')) ||
   db.include?(w.sub(/rring$/,'r')) ||
   db.include?(w.sub(/ssing$/,'s')) ||
   db.include?(w.sub(/tting$/,'t')) ||
   db.include?(w.sub(/ing$/,'e')) ||
   db.include?(w.sub(/bbed$/,'b')) ||
   db.include?(w.sub(/dded$/,'d')) ||
   db.include?(w.sub(/gged$/,'g')) ||
   db.include?(w.sub(/lled$/,'l')) ||
   db.include?(w.sub(/mmed$/,'m')) ||
   db.include?(w.sub(/nned$/,'n')) ||
   db.include?(w.sub(/pped$/,'p')) ||
   db.include?(w.sub(/rred$/,'r')) ||
   db.include?(w.sub(/ssed$/,'s')) ||
   db.include?(w.sub(/tted$/,'t')) ||
   db.include?(w.sub(/ed$/,'')) ||
   db.include?(w.sub(/ed$/,'e')) ||
   db.include?(w.sub(/ies$/,'y')))
end


data=words
       .select{|w| frequency_db.has_key?(w) }
       .select{|w| syllables_db.has_key?(w) }
       .map{|w| [w,
                 w.length,
                 syllables_db[w],
                 frequency_db[w],
                 is_adjective?(w, adjectives_db) ? '1' : '0',
                 adverbs_db.include?(w) ? '1' : '0',
                 is_noun?(w, nouns_db) ? '1' : '0',
                 is_verb?(w, verbs_db) ? '1' : '0' ] }

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

