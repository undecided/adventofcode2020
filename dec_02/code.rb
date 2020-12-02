data = File.read('data.txt').lines.map(&:strip)

# I feel it's a lambdaish type of day today...

PARSE_REGEX = /^([0-9]+)-([0-9]+) ([a-zA-Z]): ([a-zA-Z]*)$/

parse_line = ->(line) { line.scan(PARSE_REGEX).flatten }

old_system = lambda do |line|
  min, max, char, password = parse_line[line]

  (min.to_i..max.to_i).include? password.count(char)
end

new_system = lambda do |line|
  eq, neq, char, password = parse_line[line]

  password[eq.to_i + 1] == char && password[neq.to_i + 1] != char
end


old_answer = data.select(&old_system).count
new_answer = data.select(&new_system).count

puts "Old system: There are #{old_answer} valid passwords out of #{data.count}"
puts "New system: There are #{new_answer} valid passwords out of #{data.count}"
