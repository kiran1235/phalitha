		exp =[]
		
		exp << "^"

		name="*.xml"
		
		name.split("").each do |c|
			if c=="*" 
				exp << "."
				exp << "*"
			elsif c=="."
				exp << "\\"
				exp << "."
			else
				exp << c
			end
		end
		
		exp << "$"
		
		exp=exp.join
		puts exp
                regexp=Regexp.new(exp)                
                fname="abc.xml"
		matched=regexp.match(fname)
		if matched.nil?
			puts "#{fname} not matched with #{exp}"
		else
			puts "match"
		end
