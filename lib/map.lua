require "lib/json"
local class = require 'lib/middleclass'

local Map = class('Map')

local function map_read(tab)

	local layers = {}

	for k,v in pairs(tab.layers) do
		if v.type ~= "tilelayer" then break end

		layers[k] 			= {}
		layers[k].width 	= v.width
		layers[k].height 	= v.height
		layers[k].name 		= v.name
		layers[k].data 		= {}

		for i=0,v.width-1 do -- creation layers
			layers[k].data[i]={}
		end

		for y=0, v.height-1 do
			for x=0, v.width-1 do
				layers[k].data[x][y] = v.data[(y*tab.width)+x+1]-1
			end
		end
	end
	return layers
end

function Map:initialize(fichier,texture) --cree une map

	local a={}
	self.fichier 	= 	fichier
	self.json 			= 	json.decode(love.filesystem.read( fichier, nil ))
	self.layers 		= 	map_read(self.json)
	if texture == nil then texture = self.json.tilesets[1].image end

	self.LX			=	self.json.width
	self.LY			=	self.json.height
	self.tileset	=	love.graphics.newImage(texture)
	self.tileset:setFilter( "nearest", "nearest" )
	self.tileLX		=	self.json.tilewidth
	self.tileLY		=	self.json.tileheight
	self.tilesetLX	=	self.tileset:getWidth()
	self.tilesetLY	=	self.tileset:getHeight()

	self.tiles		=	{}

	for y=0,(self.tilesetLY/self.tileLY)-1 do
		for x=0,(self.tilesetLX/self.tileLX)-1 do
			self.tiles[x+(y*self.tilesetLX/self.tileLX)] = love.graphics.newQuad(x*self.tileLX,y*self.tileLY, self.tileLX, self.tileLY ,self.tilesetLX, self.tilesetLY)
		end
	end

	self.spriteBatchs = {}

	for k,v in pairs(self.layers) do
		self.spriteBatchs[k] = love.graphics.newSpriteBatch( self.tileset, self.LX*self.LY )
		self.spriteBatchs[k]:clear()

		for x=0,(self.LX)-1 do
			for y=0,(self.LY)-1 do
				local id = v.data[x][y]
				if id < 0 then print("error tile < 0 on "..v.name.." at ("..x..";"..y) id = 0 end
				self.spriteBatchs[k]:add(self.tiles[id], x*self.tileLX, y*self.tileLY)
			end
		end
	end
end



function Map:update(nb)
	if nb then
		self.spriteBatchs[nb]:clear()
		for x=0,(self.LX)-1 do
			for y=0,(self.LY)-1 do
				local id = self.layers[nb].data[x][y]
				self.spriteBatchs[nb]:add(self.tiles[id], x*self.tileLX, y*self.tileLY)
			end
		end
	else
		for k,v in ipairs(self.spriteBatchs) do
			v:clear()
			for x=0,(self.LX)-1 do
				for y=0,(self.LY)-1 do
					local id = self.layers[nb].data[x][y]
					v:add(self.tiles[id], x*self.tileLX, y*self.tileLY)
				end
			end
		end
	end
end

function Map:draw(x, y, r, sx, sy, ox, oy, kx, ky)
	for k,v in pairs(self.spriteBatchs) do
		love.graphics.draw(v, math.floor(x), math.floor(y), r, sx, sy, ox, oy, kx, ky )
	end
end

function Map:drawLayers(x,y,layers, r, sx, sy, ox, oy, kx, ky)
	for k,v in pairs(layers) do
		love.graphics.draw(self.spriteBatchs[v],math.floor(x),math.floor(y), r, sx, sy, ox, oy, kx, ky )
	end
end

function Map:getTile(x,y)
	if x<0 or y<0 or x>=self.LX or y>=self.LY then
		return nil
	else
		tile = {}
		for k,v in ipairs(self.layers) do
			tile[k] = v.data[x][y]
		end
		return tile
	end
end

function Map:setTile(x,y,id,map)
	if id >= 0 and id <= #self.tiles then
		if x<0 or y<0 or x>=self.LX or y>=self.LY then
			print("error x or y out of map")
			return nil
		end

		if map then
			self.layers[map].data[x][y]	=	id
			self:update(map)
		else
			self.layers[1].data[x][y]	=	id
			self:update(1)
		end

		return self:getTile(x,y,map)
	else
		print("error id")
		return nil
	end
end

function Map:reload()

	self.layers 	= nil
	self.layers 	= map_read(self.json)
	self:update()

end

------------------

function Map:getLX()
	return self.LX
end

function Map:getLY()
	return self.LY
end

return Map
