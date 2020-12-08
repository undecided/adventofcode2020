# Today is a loopy metaprogrammy day

CODEBASE = File.read('data.txt').lines.map(&:strip)

class Machine
  class UnMutatable < StandardError ; end
  class Halt < StandardError ; end

  def initialize(mutate_idx = nil)
    @state = {
      idx: [0],
      reg: [0], # I wanted to use acc, but it was taken
      code: CODEBASE.dup # ['nop +0', '...']
    }
    @mutate_idx = mutate_idx
    mutate
  end

  # Some convenience methods for idx / reg
  # idx -> the current index (the last in the idx array)
  # idx_becomes -> push a new index into history
  # idx_history -> all the idx's there ever were
  [:idx, :reg].each do |key|
    define_method(key) { @state[key].last }
    define_method(:"#{key}_becomes") { |val| @state[key] << val }
    define_method(:"#{key}_history") { @state[key] }
  end

  # Code is slightly different - the current line of code is the indexed line
  define_method(:codebase) { @state[:code] }
  define_method(:instruction) { codebase[idx] }

  def step
    raise Halt if idx >= codebase.length

    send(*instruction.split)
  end

  def looped?
    idx_history.uniq != idx_history
  end

  def inspect
    {instructions: idx_history.count, final_accumulator: reg}.inspect
  end

  private

  def mutate
    return unless @mutate_idx
    raise UnMutatable if @mutate_idx >= codebase.length
    item = codebase[@mutate_idx]
    raise UnMutatable if item['acc']

    codebase[@mutate_idx] = swap_instruction(item)
  end

  def swap_instruction(item)
    instruction, param = item.split
    instruction = instruction == 'jmp' ? 'nop' : 'jmp'
    "#{instruction} #{param}"
  end

  def nop(_unused)
    idx_becomes(idx + 1)
  end

  def jmp(delta)
    idx_becomes(idx + delta.to_i)
  end

  def acc(delta)
    reg_becomes(reg + delta.to_i)
    idx_becomes(idx + 1)
  end
end

machine = Machine.new

puts "Accumulator when the machine loops:"
machine.step until machine.looped?
puts machine.inspect


(0..1000).each do |n|
  begin
    machine = Machine.new(n)
    machine.step until machine.looped?
  rescue Machine::UnMutatable
    next
  rescue Machine::Halt
    puts "Halted when mutating line #{n}"
    puts machine.inspect
  end
end
