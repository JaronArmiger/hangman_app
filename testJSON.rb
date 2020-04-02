require 'json'

class A
	def initialize(string,number)
		@string = string
		@number = number
	end

	def to_s
		"In A:\n 	#{@string}, #{@number}\n"
	end

	def to_json(*a)
		{
			"json-class"  =&gt; self.class.name,
			"data"        =&gt; {"string" =&gt; @string, "number" =&gt; @number }
		}.to_json(*a)
	end

	def self.json_create(o)
		new(o["data"]["string"], o["data"]["number"])
	end
end

a = A.new("maslow's hammer", 5)
json_string = a.to_json
puts json_string