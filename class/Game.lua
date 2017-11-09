local class		= require 'lib/middleclass'
local Sprite	= require 'lib/sprite'
local Cloud		= require 'class/Cloud'
local Tweet		= require 'class/Tweet'
local Radar		= require 'class/Radar'
local Soul	 	= require 'class/Soul'
local Cell	 	= require 'class/Cell'
local Cells	 	= require 'class/Cells'
local Gamestate	= require 'lib/gamestate'

require "lib/json"

local Game = class('Game')

function Game:initialize()

	math.randomseed( os.time() )
	--self.bg				= love.graphics.newImage("media/texture/background.png")
	love.graphics.setBackgroundColor( 16, 33, 17 )

	self.grid			= love.graphics.newImage("media/texture/grille.png")
	self.holly			= love.graphics.newImage("media/texture/hollywood.png")
	self.road			= love.graphics.newImage("media/texture/route.png")
	self.rio			= love.graphics.newImage("media/texture/rio.png")
	self.bubble			= love.graphics.newImage("media/texture/bulle.png")
	self.menu			= love.graphics.newImage("media/texture/menuback.png")
	self.cellimg		= love.graphics.newImage("media/texture/cartouche.png")
	self.imgRadar = {}
	self.imgRadar.V = love.graphics.newImage("media/texture/radarV.png")
	self.imgRadar.H = love.graphics.newImage("media/texture/radarH.png")

	self.bg_music		= love.audio.newSource("media/music/bg.ogg",  "stream")
	self.sfx_pause		= love.audio.newSource("media/sfx/pause.wav", "static")

	self.pause = Sprite:new("media/sprite/pausetele.png", 412, 341, 0.08,2)
	self.pause:addAnimation({0,1,2,3,4,5,6,7,8})
	self.pause:stop()

	self.temp = Sprite:new("media/sprite/time.png", 632, 191, 1/5)
	self.temp:addAnimation({0,1,2,3,4})

	self.orb = {}
	for i=1,9 do
		self.orb[i] = Sprite:new("media/sprite/orb"..i..".png", 320, 217, .1)
		self.orb[i]:addAnimation({0,1,2,3,4,5,6,7,8,9})
	end

	self.sfx_orb = {}
	for i=1,7 do
		table.insert(self.sfx_orb, love.audio.newSource("media/sfx/Tweet"..i..".wav", "static"))
	end

	self.tweetDB = self:initTweetDB()

	self.font1 = love.graphics.newFont("media/font/Arial.ttf", 16)
	self.font2 = love.graphics.newFont("media/font/Pixel-LCD-7.ttf", 70)

	self.ps = getPS("media/particule/part", love.graphics.newImage("media/particule/square.png"))

end

function Game:enter()
	self.bg_music:play()
	self.nextGlitch = math.random(4,10)

	self.entity = {}

	math.randomseed( os.time() )
	--
	table.insert(self.entity, Cloud:new(600, math.random(-200, -1), math.random(1,2), 1, .17, self))
	table.insert(self.entity, Cloud:new(600, math.random(-200, -1), math.random(1,2), 1, .17, self))
	table.insert(self.entity, Cloud:new(600, math.random(-200, -1), math.random(1,2), 1, .17, self))


	self.radarV = Radar:new(0, 1440, "V", 0, 20, self)
	self.radarH = Radar:new(2550, 0, "H", 40, 0, self)

	self.time = 0
	self.deltaSpawn = 0

	self.radarMode = "H"

	self.tweetsSpeed = 2.5

	self.soul	= Soul:new(300,300,self)
	self.cells	= Cells:new(self)

	self.counter = (2 * 60) + 40
	self.deltaSpawnUp	= 1
	self.deltaSpawnDown = 2

	self.stat = {
		spirit	= 0,
		art		= 0,
		news	= 0,
		nature	= 0,
		social	= 0,
		jeu		= 0,
		tech	= 0
	}

	self.sx = sx
	self.sy = sy

	self.ps:setPosition(-1000,-1000)

end

function Game:resume()
	self.bg_music:play()
end

function Game:initTweetDB()
	local db = json.decode(love.filesystem.read( "media/tweets.json", nil))
	local tweetDB = {}

	for k,v in pairs(db) do
		for l,w in pairs(v) do
			table.insert(tweetDB, {txt = w, cat = k})
		end
	end
	return tweetDB
end

function Game:update(dt)
	self.time			= self.time				+ dt
	self.counter		= self.counter			- dt
	self.deltaSpawnUp	= self.deltaSpawnUp		- dt
	self.deltaSpawnDown	= self.deltaSpawnDown	- dt
	self.nextGlitch		= self.nextGlitch		- dt

	if (self.nextGlitch <= 0) then
		self.pause:play()
		self.nextGlitch = math.random(3,6)
	end

	self.ps:update(dt)

	if (self.deltaSpawnUp <= 0) then
		table.insert(self.entity, 1,Tweet:new(-320, 75 + math.random(0,80), self.tweetDB[math.random(1, #self.tweetDB)], 1 * self.tweetsSpeed, .17 * self.tweetsSpeed, self))
		self.deltaSpawnUp = math.random(8 / self.tweetsSpeed, 10 / self.tweetsSpeed)
	end

	if (self.deltaSpawnDown <= 0) then
		table.insert(self.entity, 1,Tweet:new(-320, 722 + math.random(0,80), self.tweetDB[math.random(1, #self.tweetDB)], 1 * self.tweetsSpeed, .17 * self.tweetsSpeed, self))
		self.deltaSpawnDown = math.random(8 / self.tweetsSpeed, 10 / self.tweetsSpeed)
	end

	for k,v in ipairs(self.entity) do
		v:update(dt)
	end

	if (self.radarMode == "H") then
		if (self.radarH:finish()) then
			self.radarMode = "V"
			self.radarV:reset()
		end
	else
		if (self.radarV:finish()) then
			self.radarMode = "H"
			self.radarH:reset()
		end
	end

	self.cells:update(dt)
	self.radarV:update(dt)
	self.radarH:update(dt)
	self.soul:update(dt)
	self.temp:update(dt)

	for i=1,9 do
		self.orb[i]:update(dt)
	end

	if (self.counter <= 0) then
		self.bg_music:stop()
		Gamestate.switch(final, self.stat)
	end
	self.pause:update(dt)
end

function Game:draw()
	--love.graphics.draw(self.bg, 0 * self.sy, 0 * self.sy, 0, self.sx, self.sy)

	love.graphics.setColor(255, 255, 255, ((math.sin(self.time*8) + 1) / 2) * (255 - 30) + 30)
	love.graphics.draw(self.grid, 0 * self.sy, 0 * self.sy, 0, self.sx, self.sy)
	love.graphics.setColor(255, 255, 255, 255)

	self.radarV:draw()
	self.radarH:draw()

	love.graphics.draw(self.road, 0 * self.sy, 0 * self.sy, 0, self.sx, self.sy)
	love.graphics.draw(self.holly, 0 * self.sy, 0 * self.sy, 0, self.sx, self.sy)

	for k,v in ipairs(self.entity) do
		v:draw()
	end

	self.soul:draw()

	love.graphics.draw(self.rio, 0 * self.sy, 696 * self.sy, 0, self.sx, self.sy)
	love.graphics.draw(self.menu, 2148 * self.sx, 0, 0, self.sx, self.sy)

	self.cells:draw()

	--love.graphics.draw(self.pause, 2148 * self.sx, 0, 0, self.sx, self.sy)
	self.pause:draw(2148 * self.sx, 0, 0, self.sx, self.sy)

	self.temp:draw(1174 * self.sx, (1440 - self.temp.ly) * self.sy, 0, self.sx, self.sy)
	love.graphics.setFont(self.font2)
	love.graphics.setColor(199,248,178)
	love.graphics.print(string.format("%02d:%02d", math.floor(self.counter/60), self.counter%60), 1228 * self.sx, 1318 * self.sy, 0, self.sx * 2, self.sy * 2)
	love.graphics.setColor(255,255,255)
	-- love.graphics.setFont(self.font1)
	-- love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10, 0, self.sx * 2, self.sy * 2)
	-- love.graphics.print("Entity: " .. #self.entity, 10, 30, 0, self.sx * 2, self.sy * 2)
	-- love.graphics.print("#cells: " .. #self.cells.cells, 10, 60, 0, self.sx * 2, self.sy * 2)
	-- love.graphics.print("next: " .. self.cells.next, 10, 80, 0, self.sx * 2, self.sy * 2)
	--
	-- love.graphics.print("json: " .. json.encode(self.stat), 10, 100, 0, self.sx * 2, self.sy * 2)

	love.graphics.setBlendMode('add')
	love.graphics.draw(self.ps, 0, 0)
	love.graphics.setBlendMode('alpha')

end


function Game:keypressed(key)
	--self.cells:destroy()
	print(key)

	if key == 'escape' then
		self.bg_music:pause()
		self.sfx_pause:play()
		Gamestate.push(pause)
	end
	if key == "a" then
		self.bg_music:stop()
		Gamestate.switch(final, self.stat)
	end
end

function Game:mousepressed(x, y, button)
	x = x / self.sx
	y = y / self.sy
	-- print("game",x,y,button)
	self.soul:mousepressed(x, y, button)
	for k,v in ipairs(self.entity) do
		v:mousepressed(x, y, button)
	end

	if (x > 2148 and x < 2560 and y > 0 and y < self.pause.ly) then
		self.bg_music:pause()
		self.sfx_pause:play()
		Gamestate.push(pause)
	end
end

function Game:mousereleased(x, y, button)
	-- print("game",x,y,button)
	self.soul:mousereleased(x / self.sx, y / self.sy, button)
end

function Game:leave()
	print("stop")
	self.bg_music:stop()
end

function getPS(name, image)
    local ps_data = require(name)
    local particle_settings = {}
    particle_settings["colors"] = {}
    particle_settings["sizes"] = {}
    for k, v in pairs(ps_data) do
        if k == "colors" then
            local j = 1
            for i = 1, #v , 4 do
                local color = {v[i], v[i+1], v[i+2], v[i+3]}
                particle_settings["colors"][j] = color
                j = j + 1
            end
        elseif k == "sizes" then
            for i = 1, #v do particle_settings["sizes"][i] = v[i] end
        else particle_settings[k] = v end
    end
    local ps = love.graphics.newParticleSystem(image, particle_settings["buffer_size"])
    ps:setAreaSpread(string.lower(particle_settings["area_spread_distribution"]), particle_settings["area_spread_dx"] or 0 , particle_settings["area_spread_dy"] or 0)
    ps:setBufferSize(particle_settings["buffer_size"] or 1)
    local colors = {}
    for i = 1, 8 do
        if particle_settings["colors"][i][1] ~= 0 or particle_settings["colors"][i][2] ~= 0 or particle_settings["colors"][i][3] ~= 0 or particle_settings["colors"][i][4] ~= 0 then
            table.insert(colors, particle_settings["colors"][i][1] or 0)
            table.insert(colors, particle_settings["colors"][i][2] or 0)
            table.insert(colors, particle_settings["colors"][i][3] or 0)
            table.insert(colors, particle_settings["colors"][i][4] or 0)
        end
    end
    ps:setColors(unpack(colors))
    ps:setColors(unpack(colors))
    ps:setDirection(math.rad(particle_settings["direction"] or 0))
    ps:setEmissionRate(particle_settings["emission_rate"] or 0)
    ps:setEmitterLifetime(particle_settings["emitter_lifetime"] or 0)
    ps:setInsertMode(string.lower(particle_settings["insert_mode"]))
    ps:setLinearAcceleration(particle_settings["linear_acceleration_xmin"] or 0, particle_settings["linear_acceleration_ymin"] or 0,
                             particle_settings["linear_acceleration_xmax"] or 0, particle_settings["linear_acceleration_ymax"] or 0)
    if particle_settings["offsetx"] ~= 0 or particle_settings["offsety"] ~= 0 then
        ps:setOffset(particle_settings["offsetx"], particle_settings["offsety"])
    end
    ps:setParticleLifetime(particle_settings["plifetime_min"] or 0, particle_settings["plifetime_max"] or 0)
    ps:setRadialAcceleration(particle_settings["radialacc_min"] or 0, particle_settings["radialacc_max"] or 0)
    ps:setRotation(math.rad(particle_settings["rotation_min"] or 0), math.rad(particle_settings["rotation_max"] or 0))
    ps:setSizeVariation(particle_settings["size_variation"] or 0)
    local sizes = {}
    local sizes_i = 1
    for i = 1, 8 do
        if particle_settings["sizes"][i] == 0 then
            if i < 8 and particle_settings["sizes"][i+1] == 0 then
                sizes_i = i
                break
            end
        end
    end
    if sizes_i > 1 then
        for i = 1, sizes_i do table.insert(sizes, particle_settings["sizes"][i] or 0) end
        ps:setSizes(unpack(sizes))
    end
    ps:setSpeed(particle_settings["speed_min"] or 0, particle_settings["speed_max"] or 0)
    ps:setSpin(math.rad(particle_settings["spin_min"] or 0), math.rad(particle_settings["spin_max"] or 0))
    ps:setSpinVariation(particle_settings["spin_variation"] or 0)
    ps:setSpread(math.rad(particle_settings["spread"] or 0))
    ps:setTangentialAcceleration(particle_settings["tangential_acceleration_min"] or 0, particle_settings["tangential_acceleration_max"] or 0)
    return ps
end

return Game
