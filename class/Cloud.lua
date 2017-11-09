local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'

local Cloud = class('Cloud')

function Cloud:initialize(posX, posY, textureNb, speedX, speedY, game)

	self.posX =  posX or 0
	self.posY =  posY or 0
	self.textureNb =  textureNb or 1

	self.sprite = love.graphics.newImage("media/texture/nuage" .. textureNb .. ".png")
	self.dX = speedX
	self.dY = speedY

	self.game = game

end

function Cloud:draw()
	love.graphics.draw(self.sprite, self.posX * self.game.sx, self.posY * self.game.sy, 0, self.game.sx, self.game.sy)
end

function Cloud:update(dt)

	self.posX = self.posX + self.dX
	self.posY = self.posY + self.dY

end

function Cloud:getPosX()
	return self.posX
end

function Cloud:getPosY()
	return self.posX
end

function Cloud:mousepressed(x, y, button)
	-- body...
end

return Cloud
