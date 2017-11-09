local class 	= require 'lib/middleclass'
local Sprite 	= require 'lib/sprite'
local tween		= require 'lib/tween'
local Cell	 	= require 'class/Cell'



local Cells = class('Cells')

function Cells:initialize(game)

	self.game = game

	self.cells = {}
	self.imgs = {
		empty	= {love.graphics.newImage("media/texture/emovide.png")},
		art		= {}, -- 5
		news	= {}, -- 5
		jeu		= {}, -- 6
		nature	= {}, -- 5
		social	= {}, -- 5
		spirit	= {}, -- 4
		tech	= {}  -- 7
	}

	for i=1, 6 do
		table.insert(self.imgs.jeu, love.graphics.newImage("media/texture/emojeu"..i..".png"))
	end

	for i=1, 5 do
		table.insert(self.imgs.news, love.graphics.newImage("media/texture/emohumain"..i..".png"))
		table.insert(self.imgs.art, love.graphics.newImage("media/texture/emoart"..i..".png"))
		table.insert(self.imgs.nature, love.graphics.newImage("media/texture/emonature"..i..".png"))
		table.insert(self.imgs.social, love.graphics.newImage("media/texture/emosocial"..i..".png"))
	end

	for i=1, 7 do
		table.insert(self.imgs.tech, love.graphics.newImage("media/texture/emotech"..i..".png"))
	end

	for i=1, 4 do
		table.insert(self.imgs.spirit, love.graphics.newImage("media/texture/emospiritualite"..i..".png"))
	end


	self.sfx_boom 	= love.audio.newSource("media/sfx/boom.wav", "static")


	self.next = 1

	for i=0,4 do
		table.insert(self.cells, Cell:new(2148, 341 + ((218 * 4) - (i * 218)), nil, self.game))
	end
end

function Cells:draw()
	for k,v in ipairs(self.cells) do
		v:draw(dt)
	end
end

function Cells:update(dt)
	for k,v in ipairs(self.cells) do
		v:update(dt)
	end
	-- if (#self.cells > 5) and (not self.cells[1].isdead) then
	-- 	self:destroy()
	-- end
end

function Cells:getPosX()
	return self.posX
end

function Cells:getPosY()
	return self.posX
end

function Cells:destroy()
	if #self.cells > 0 then
		if not self.cells[1].isdead then
			self.cells[1]:destroy()
			if  self.next > 1 then
				self.next = self.next - 1
			end
		end
	end
end

function Cells:down()
	self.sfx_boom:play()
	for k,v in ipairs(self.cells) do
		v:down()
	end
end

function Cells:add(text)
	if (self.next == 6) then
		--self:destroy()
		table.insert(self.cells, Cell:new(2148, 341 - 218, text ,self.game))
		self.cells[1]:destroy()
	elseif (#self.cells < 1 or self.next > #self.cells) then
		table.insert(self.cells, Cell:new(2148, 341 - 218, text, self.game))
	else
		self.cells[self.next].text = text
		print(text, self.cells[self.next].nb[text])
		self.cells[self.next].nbTexture = math.random(1, self.cells[self.next].nb[text])
		self.next = self.next + 1
	end
	self.game.stat[text] = self.game.stat[text] + 1
end

function Cells:mousepressed(x, y, button)
	-- print("Cells",x,y,button)
end

return Cells
