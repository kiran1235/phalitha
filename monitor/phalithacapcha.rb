require 'rmagick'


module PhalithaCapcha
	def self.generate(digits,targetlocation)
		granite = Magick::ImageList.new('granite:')
		canvas = Magick::ImageList.new
		canvas.new_image(100, 50, Magick::TextureFill.new(granite))
		text = Magick::Draw.new
		text.font_family = 'helvetica'
		text.pointsize = 16
		text.gravity = Magick::CenterGravity
		text.annotate(canvas, 0,0,2,2, digits) {
			self.fill = 'gray83'
		}

		text.annotate(canvas, 0,0,-1.5,-1.5, digits) {
			self.fill = 'gray40'
		}

		text.annotate(canvas, 0,0,0,0, digits) {
			self.fill = 'darkred'
		}
		
		canvas.write(targetlocation)
		
	end
end
