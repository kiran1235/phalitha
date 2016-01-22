   	name="*.xml"
	exp=Regexp.new("^.*\\.xml$")
	fname="abc.xml"
	matched=exp.match(fname)
	p exp
	p matched
