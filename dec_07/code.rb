data = File.read('data.txt').lines.map { |l| l.strip.chomp('.') }

# Today is a hacky scripty day.

quantities = data.each_with_object({forward: {}, reverse: {}}) do |line, accumulator| # line = 'x y contain 2 a b c, 3 i j'
  bag, content = line.split(' bags contain ')
  content = content.split(', ').flat_map do |item| # item = '2 bright green bags'
    qty, *child, _ = item.split(' ')
    [child.join(' ')] * qty.to_i
  end
  accumulator[:forward][bag] = content
  content.uniq.each do |child|
    accumulator[:reverse][child] ||= []
    accumulator[:reverse][child] |= [bag]
  end
end

def gather_nodes(hash, root)
  return [root] unless hash[root]

  hash[root].map { |child| [root, gather_nodes(hash, child)]}.flatten.uniq
end

def multiply_nodes(hash, root)
  return [root] if hash[root].empty?

  [root, hash[root].map { |child| multiply_nodes(hash, child) }].flatten
end


containers = gather_nodes(quantities[:reverse], 'shiny gold').count - 1 # exclude original bag
puts "There are #{containers} bags that could contain shiny gold"

contents = multiply_nodes(quantities[:forward], 'shiny gold').count - 1 # exclude original bag
puts "Shiny gold bags contain #{contents} child bags"
