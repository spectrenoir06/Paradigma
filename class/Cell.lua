local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'
local tween		= require 'lib/tween'


local Cell = class('Cell')

function Cell:initialize(posX, posY, text, game)

	self.posX =  posX or 0
	self.posY =  posY or 0

	self.game = game

	self.img = self.game.cellimg

	self.destroyTween	= tween.new(1, self, {posX=2560}, 'outBounce')
	self.downTween		= tween.new(1, self, {posY=self.posY + 218}, 'outBounce')
	self.goDown = false

	self.text = text or "empty"

	self.nb = {
		empty	= 1,
		spirit	= 4,

		art		= 5,
		news	= 5,
		nature	= 5,
		social	= 5,

		jeu		= 6,

		tech	= 7
	}

	self.nbTexture = math.random(1, self.nb[self.text])
	print(self.nbTexture)

end

function Cell:draw()

	love.graphics.draw(	self.img,
						self.posX * self.game.sx,
						self.posY * self.game.sy,
						0,
						self.game.sx,
						self.game.sy
					)
	-- love.graphics.print(
	-- 					self.text,
	-- 					(self.posX + 50) * self.game.sx,
	-- 					(self.posY + 50) * self.game.sy
	-- 					)
	--print(self.text)
	love.graphics.draw(	self.game.cells.imgs[self.text][self.nbTexture],
						(self.posX + 71) * self.game.sx,
						(self.posY + 42) * self.game.sy,
						0,
						self.game.sx,
						self.game.sy
					)

	end

function Cell:update(dt)
	if self.dead then
		self.destroyTween:update(dt)
		if self.destroyTween.clock >= self.destroyTween.duration then
			self.game.cells:down();
			self.game.ps:start()
			self.game.ps:setPosition(2366*self.game.sx, 1440*self.game.sy)
			table.remove(self.game.cells.cells, 1)
		end
	end
	if self.goDown then
		self.downTween:update(dt)
		if self.downTween.clock >= self.downTween.duration then
			self.downTween = tween.new(1, self, {posY=self.posY + 218}, 'outBounce')
			self.goDown = false
		end
	end
end

function Cell:destroy()
	self.dead = true

end

function Cell:getPosX()
	return self.posX
end

function Cell:getPosY()
	return self.posX
end

function Cell:down()
	self.goDown = true
end

return Cell
