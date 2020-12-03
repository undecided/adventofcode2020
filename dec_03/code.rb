data = File.read('data.txt').lines.map(&:strip)

# Today, I feel like being fancy shmancy

class CyclicMap
  class Bottom < StandardError; end

  def initialize(data)
    @data = to_2d_boolean_array data
    @cursor = {x: 0, y: 0}
  end

  def tree?(x = @cursor[:x], y = @cursor[:y])
    raise Bottom if y >= @data.length

    @data[y][x % sample_width]
  end

  def increment_cursor(x:, y:)
    @cursor[:x] += x
    @cursor[:y] += y
    self
  end

  private

  def sample_width
    @data.first.length
  end

  def to_2d_boolean_array(data)
    data.map do |line|
      line.chars.map { |char| char == '#' }
    end
  end
end

class TreeCounter
  def initialize(data, delta_x:, delta_y:)
    @map = CyclicMap.new(data)
    @delta_x = delta_x
    @delta_y = delta_y
    @count = @map.tree? ? 1 : 0
  end

  def run
    while true
      @count +=1 if @map.increment_cursor(x: @delta_x, y: @delta_y).tree?
    end
  rescue CyclicMap::Bottom
    puts "There are #{@count} trees blocking the path #{'🡆 ' * @delta_x} #{'🡇 ' * @delta_y}"
    @count
  end

end

tree_counters = [
  {delta_x: 1, delta_y: 1},
  {delta_x: 3, delta_y: 1},
  {delta_x: 5, delta_y: 1},
  {delta_x: 7, delta_y: 1},
  {delta_x: 1, delta_y: 2},
].map { |config| TreeCounter.new(data, **config) }

total = tree_counters.map { |counter| counter.run }.inject(&:*)

puts "All the trees multiplied together comes to #{total}"
