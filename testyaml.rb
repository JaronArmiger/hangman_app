require 'yaml'

class A
  def initialize(string, number)
    @string = string
    @number = number
  end

  def to_s
    "In A:\n   #{@string}, #{@number}\n"
  end
end

class B
  def initialize(number, a_object)
    @number = number
    @a_object = a_object
  end

  def to_s
    "In B: #{@number} \n  #{@a_object.to_s}\n"
  end
end

class C
  def initialize(b_object, a_object)
    @b_object = b_object
    @a_object = a_object
  end

  def to_s
    "In C:\n #{@a_object} #{@b_object}\n"
  end
end

a = A.new("hello world", 5)
b = B.new(7, a)
c = C.new(b, a)

=begin
File.open('/Users/jaronarmiger/Documents/new-folder/odin1/hangman/blah.yaml', 'w') do |file|
  (1..10).each do |index|
    file.puts YAML::dump(A.new("fuck you", index))
    file.puts ''
  end
end
=end

array = []
$/='\n\n'
File.open('/Users/Documents/new-folder/odin1/blah.yaml', 'r').each do |object|
  array &lt;&lt; YAML::load(object)
end

puts array