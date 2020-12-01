data = File.read('data.txt').split.map(&:strip).map(&:to_i)
part_1 = data.permutation(2).find { |(x, y)| x + y == 2020 }.inject(&:*)
part_2 = data.permutation(3).find { |(x, y, z)| x + y + z == 2020 }.inject(&:*)

puts "Part 1 answer: #{part_1}"
puts "Part 2 answer: #{part_2}"
