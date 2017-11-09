local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'

local Radar = class('Radar')

function Radar:initialize(posX, posY, texture, speedX, speedY, game)

	self.posX =  posX or 0
	self.posY =  posY or 0
	self.texture =  texture

	self.sprite = game.imgRadar[texture]
	self.dX = speedX
	self.dY = speedY

	self.game = game

end

function Radar:draw()
	love.graphics.draw(self.sprite, self.posX * self.game.sx, self.posY * self.game.sy, 0, self.game.sx, self.game.sy)
end

function Radar:update(dt)

	self.posX = self.posX + self.dX
	self.posY = self.posY + self.dY

end

function Radar:getPosX()
	return self.posX
end

function Radar:getPosY()
	return self.posX
end

function Radar:finish()
	return self.posX > 2560 or self.posY > 1440
end

function Radar:reset()
	if (self.texture == "H") then
		self.posX = -self.sprite:getWidth()
	elseif (self.texture == "V") then
		self.posY = -self.sprite:getHeight()
	end
end

return Radar
