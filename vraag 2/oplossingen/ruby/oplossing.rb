1.upto(100) do |i|
	s = ""
	s << "Fizz" if i % 3 == 0
	s << "Buzz" if i % 5 == 0
	puts s.empty? ? i : s
end