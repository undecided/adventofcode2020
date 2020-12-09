data = File.read('data.txt').lines.map(&:to_i)
preamble = 25

# Today is a day for horrible one-liners, prettified somewhat for your consumption

puts "Part 1"
invalid = data.each_with_index.reject do |n, idx|
  next true if idx < preamble
  data[[0, idx - preamble].max...idx].combination(2).map(&:sum).include?(n)
end.first
puts "The bad item is #{invalid.inspect}"

puts "Part 2"
n, idx = invalid
(2..idx).each do |c|
  data[0...idx].each_cons(c) do |arr|
    raise "Answer is #{arr.max + arr.min}" if arr.sum == n
  end
end
