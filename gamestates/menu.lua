menu = {}
local class		= require 'lib/middleclass'
local Gamestate	= require 'lib/gamestate'
local Sprite	= require 'lib/sprite'

function menu:enter()
		menu_bg_music:play()
end

function menu:init()
	menubg1		= love.graphics.newImage("media/texture/menubg1.png")
	menubg2		= love.graphics.newImage("media/texture/menubg2.png")
	start		= love.graphics.newImage("media/texture/pressstart.png")
	credit		= love.graphics.newImage("media/texture/credits.png")
	pausetext	= love.graphics.newImage("media/texture/pausetexte.png")

	sfx_start	= love.audio.newSource("media/sfx/start.wav", "static")
	start:setFilter( "nearest", "nearest" )

	logo = Sprite:new("media/sprite/paradigma.png", 2560, 535, 0.08, 2)
	logo:addAnimation({0,1,2,1,0})
	logo:stop()

	menu_bg_music = love.audio.newSource("media/music/menu.ogg", "stream")
	menu_bg_music:setLooping(true)

	creditX = 0

	nextGlitch = math.random(4,10)
	time = 0

	sx	= .5
	sy	= .5

	if love.system.getOS() == "Android" then
		local width, height = love.window.getDesktopDimensions()
		--love.window.setMode(width, height, {fullscreen = true})
		sx = width / 2560
		sy = sx
		--fullscreen = true
	end
end

function menu:update(dt)
	time = time + dt
	nextGlitch = nextGlitch - dt
	if (nextGlitch < 0) then
		logo:play()
		nextGlitch = math.random(3,6)
	end
	creditX = (creditX - (dt * 200)) % credit:getWidth()
	logo:update(dt)
end

function menu:draw()
	love.graphics.draw(menubg1, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 30) + 30)
	love.graphics.draw(menubg2, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 180) + 180)
	logo:draw(0,0,0, sx, sy)
	love.graphics.draw(credit, creditX * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.draw(credit, (creditX - credit:getWidth()) * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(start, 863 * sx, (800 + math.sin(time*8) * 5) * sy, 0 , sx, sy)
end

function menu:mousepressed(x,y,button)
	x = x / sx
	y = y / sy
	print(x,y,button)
	if (x > 863 and x < (863 + start:getWidth()) and y > 800 and y < (800 + start:getHeight())) then
		sfx_start:play()
		Gamestate.switch(howto)
	end
end

function menu:keypressed(key)
	print(key)
	if (key == ' ') then
		sfx_start:play()
		menu_bg_music:stop()
		Gamestate.switch(howto)
	-- elseif key == 'escape' then
	-- 	love.event.quit()
end
if key == "f11" then
	if not fullscreen then
		local width, height = love.window.getDesktopDimensions()
		love.window.setMode(width, height, {fullscreen = true})
		sx = width / 2560
		sy = sx
		fullscreen = true
	else
		love.window.setMode(1280, 720, {fullscreen = false})
		sx = .5
		sy = .5
		fullscreen = false
	end
end
end
