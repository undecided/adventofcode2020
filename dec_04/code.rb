data = File.read('data.txt').split("\n\n").map { |item| Hash[*item.split(/[\s\:]/)]}

def valid_height?(hgt)
  _, value, units = hgt.match(/^(\d+)(.+)$/).to_a
  (units == 'cm' && value.to_i.between?(150, 193)) ||
    (units == 'in' && value.to_i.between?(59, 76))
end

EYE_COLOURS = %w[amb blu brn gry grn hzl oth]

VALIDATIONS = {
  "byr" => ->(byr) { byr.length == 4 && byr.to_i.between?(1920, 2002) },
  "iyr" => ->(iyr) { iyr.length == 4 && iyr.to_i.between?(2010, 2020) },
  "eyr" => ->(eyr) { eyr.length == 4 && eyr.to_i.between?(2020, 2030) },
  "hgt" => ->(hgt) { valid_height?(hgt) },
  "hcl" => ->(hcl) { hcl[/^\#[0-9a-f]{6}$/i] },
  "ecl" => ->(ecl) { EYE_COLOURS.include? ecl },
  "pid" => ->(pid) { pid[/^[0-9]{9}$/] },
}

answer = data.select do |passport|
  passport.delete('cid')
  passport.each_pair.select do |k, v|
    VALIDATIONS[k][v]
  end.length == VALIDATIONS.length
end.count


puts "There are #{answer} valid passports out of #{data.length}"
