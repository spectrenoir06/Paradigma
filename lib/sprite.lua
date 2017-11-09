local class = require 'lib/middleclass'

local Sprite = class('Sprite')



function Sprite:initialize(file, lx, ly, delay, mode)

	self.img	= love.graphics.newImage(file)  -- load Texture
    self.img:setFilter( "nearest", "nearest" )
	self.frame  = {}							-- tab of Quad
	self.width  = self.img:getWidth()		   -- width of texture
	self.height = self.img:getHeight()		  -- height of texture
	self.lx = lx
	self.ly = ly

	for y=0,(self.height/ly)-1 do
			for x=0,(self.width/lx)-1 do
				self.frame[x+(y*(self.width/lx))] = love.graphics.newQuad(x*lx,y*ly,lx,ly ,self.width, self.height)
			end
	end


	self.tabAnim= {}				-- tab of animation
	self.delay  = delay or 0.25		-- delay between frame
	self.anim   = 1
	self.speed  = 1
	self.timer  = 0
	self.pos	= 1
	self.isPlay = true
	self.mode   = mode or 1			 -- mode 1 = "bounce"

end

function Sprite:draw(x,y,r,sx,sy)
	love.graphics.draw(self.img, self.frame[self.tabAnim[self.anim][self.pos]], x, y, r, sx, sy)
end

function Sprite:drawframe(x,y,frame)
	love.graphics.draw(self.img,self.frame[frame],x,y)
end

function Sprite:addAnimation(Tframe)
	table.insert(self.tabAnim, Tframe)
end

function Sprite:update(dt)
	 if self.isPlay then
		self.timer = self.timer + dt * self.speed
		if self.timer > self.delay then
			self.timer = self.timer - self.delay
			self.pos = self.pos + 1
			if self.pos > #self.tabAnim[self.anim] then
				if self.mode == 1 then
					self.pos = 1
				elseif self.mode == 2 then
					self.pos = self.pos - 1
					self:stop()
				end
			end
		end
	 end
end

function Sprite:setAnim(nb,frame)
	if frame then
		self.timer = 0
		self.pos = frame
	elseif (self.anim ~= nb) then
		self.pos = 1
		self.timer = 0
	end

	self.anim = nb
end

function Sprite:play()
	self.isPlay = true
end

function Sprite:stop()
	self.isPlay = false
	self:set(1)
end

function Sprite:reset()
	self:set(1)
end

function Sprite:set(frame)
	self.pos = frame
	self.timer = 0
end

function Sprite:getCurrentFrame()
	return self.pos
end

function Sprite:setMode(mode)
	if mode == "loop" then
		self.mode = 1
	elseif mode == "once" then
		self.mode = 2
	end
end

return Sprite
