class Contexttoken < ActiveRecord::Base
  validates :context_token_data, presence: true
  belongs_to :context
  before_create :setup_context_token
  def setup_context_token
	i=0
	tokens=[]
	while i<100:
		tokens.push(SecureRandom.hex(16))
		i++
	end
	
	usedtokens=[]
	Contexttoken.where(:context_token =>tokens).each do |t|
		usedtokens.push(t.context_token)
	end
	
	notusedtokens=tokens-usedtokens
	self.context_token=notusedtokens[0]
	
  end  
end
