local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'
local tween		= require 'lib/tween'


local Tweet = class('Tweet')

function Tweet:initialize(posX, posY, mess, speedX, speedY, game)

	self.posX =  posX or 0
	self.posY =  posY or 0

	self.game = game

	self.offMess = {x = 150, y = -200}
	self.offOrb = {x = 0, y = 0}

	self.mess =  mess.txt

	self.orb = self.game.orb[math.random(1, 9)]
	self.bubble = self.game.bubble
	self.bubbleSx = 0
	self.bubbleSy = 0
	self.bubblePop = false
	self.bubbleOpa = 255

	self.type = mess.cat

	self.dX = speedX
	self.dY = speedY

end

function Tweet:draw()

	if not self.dead then
		self.orb:draw(	(self.posX + self.offOrb.x) * self.game.sx,
						(self.posY + self.offOrb.y) * self.game.sy,
						0,
						self.game.sx,
						self.game.sy
					)
	end

	love.graphics.setColor(255, 255, 255, self.bubbleOpa)
	love.graphics.draw(	self.bubble,
						(self.posX + self.offMess.x) * self.game.sx,
						(self.posY + self.offMess.y + ((((self.bubbleSy - .5) * -1) + .5) * 281)) * self.game.sy,
						0,
						self.game.sx * self.bubbleSx,
						self.game.sy * self.bubbleSy
					)

	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.setFont(self.game.font1)
	love.graphics.printf(	self.mess,
							(self.posX + self.offMess.x + 15) * self.game.sx,
							(self.posY + self.offMess.y + 15 + ((((self.bubbleSy - .5) * -1) + .5) * 281)) * self.game.sy,
							200,
							"left",
							0,
							self.game.sy * 2 * self.bubbleSx,
							self.game.sy * 2 * self.bubbleSy
						)
	love.graphics.setColor(255, 255, 255, 255)
end

function Tweet:update(dt)

	if not self.dead then
		self.posX = self.posX + self.dX
		self.posY = self.posY + self.dY
	end
	--self.orb:update(dt)

	if self.posX > -100 then
		if not self.bubblePop and not self.dead then
			self.bubbleTween = tween.new(1, self, {bubbleSx=1, bubbleSy=1}, 'outElastic')
			self.bubblePop = true
		end
	end

	if self.bubblePop then
		self.bubbleTween:update(dt)
	end
	if (self.posX > 2560) then
		for k,v in ipairs(self.game.entity) do
			if (self == v) then
				--print("del")
				table.remove( self.game.entity, k )
				collectgarbage()
			end
		end
	end

end

function Tweet:getPosX()
	return self.posX
end

function Tweet:getPosY()
	return self.posX
end

function Tweet:mousepressed(x, y, button)
	if (
		x >= (self.posX + self.offMess.x) and
		x < (self.posX + self.offMess.x + self.bubble:getWidth()) and
		y > (self.posY + self.offMess.y) and
		y < (self.posY + self.offMess.y + self.bubble:getHeight()) and
		self.bubblePop and
		not self.dead
	) then
		local i = math.random(1,7)
		if self.game.sfx_orb[i]:isPlaying() then
			self.game.sfx_orb[i]:rewind()
		else
			self.game.sfx_orb[i]:play()
		end
		self.game.cells:add(self.type)
		--print(self.game.cells.next)
		self.bubbleTween = tween.new(	1,
										self,
										{
											posX=self.game.cells.cells[self.game.cells.next-1].posX - self.offMess.x,
											posY=self.game.cells.cells[self.game.cells.next-1].posY - self.offMess.y,
											bubbleSx=0.2,
											bubbleSy=0.2,
											bubbleOpa=0
										},
										'outExpo')
		self.dead = true
		--self.bubblePop = false
	end

end

return Tweet
