local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'
local tween		= require 'lib/tween'


local Soul = class('Soul')

function Soul:initialize(posX, posY, game)

	self.posX =  posX or 0
	self.posY =  posY or 0

	self.sprite = Sprite:new("media/sprite/soul.png", 272, 281, .1)

	self.sprite:addAnimation({0,1,2,3,4})

	self.game = game
end

function Soul:draw()

	self.sprite:draw(	self.posX * self.game.sx,
						self.posY * self.game.sy,
						0,
						self.game.sx,
						self.game.sy
					)
end

function Soul:update(dt)

	self.sprite:update(dt)

	if self.isGrab then
		self.posX = (love.mouse.getX() / self.game.sx) - self.grabDx
		self.posY = (love.mouse.getY() / self.game.sy) - self.grabDy
	end
end

function Soul:getPosX()
	return self.posX
end

function Soul:getPosY()
	return self.posX
end

function Soul:mousepressed(x, y, button)
	--print(x,y,button)
	if (	not self.isGrab and
			x >= self.posX and
			x < (self.posX + self.sprite.lx) and
			y >= self.posY and
			y < (self.posY + self.sprite.ly)
		) then
		self.grabX = x
		self.grabY = y
		self.grabDx = x - self.posX
		self.grabDy = y - self.posY
		self.isGrab = true
	end
end

function Soul:mousereleased(x, y, button)
	--print("r",x,y)
	self.isGrab = false
end

return Soul
