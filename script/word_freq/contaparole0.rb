#!/usr/local/bin/ruby
require_relative "words_from_string.rb"
require_relative "count_frequency.rb"
p "prova contaparole0.rb"
raw_text = %{Il problema si divide in due parti. In primo luogo abbiamo etc}
p "inspect=#{raw_text.inspect}; #{raw_text}."
#counts = count_frequency(raw_text)
#p "counts.inspect"
#p words_from_string("But I didn't inhale, he said (emphatically)")
word_list = words_from_string(raw_text)
p word_list
counts = count_frequency(word_list)
sorted = counts.sort_by {|word, count| count}
top_five = sorted.last(5)
p "#{sorted.inspect}"
p "#{top_five.inspect}"
#
for i in 0...5        # (this is ugly code--read on
word = top_five[i][0] # for a better version)
count = top_five[i][1]
puts "#{word}: #{count}"
end
# la versione migliore potrebbe essere di visitare top_five come hash
top_five.each {|key, value| puts "#{key} conta #{value}" }

