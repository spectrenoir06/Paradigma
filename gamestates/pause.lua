pause = {}
local class		= require 'lib/middleclass'
local Gamestate	= require 'lib/gamestate'
local Sprite	= require 'lib/sprite'


function pause:enter()
	bg_music_pause:play()
	time = 0
	nextGlitch = math.random(3,6)
end

function pause:init()

	logo_pause = Sprite:new("media/sprite/pause.png", 2560, 686, 0.08, 2)
	logo_pause:addAnimation({0,1,2,1,0})
	logo_pause:stop()

	resume	= love.graphics.newImage("media/texture/reprendre.png")
	quit	= love.graphics.newImage("media/texture/quit.png")

	bg_music_pause = love.audio.newSource("media/music/pause.ogg", "stream")
	bg_music_pause:setLooping(true)

	posY_button = 686
	posX_resume = 1516
	posX_quit = 464

end

function pause:update(dt)
	time = time + dt
	nextGlitch = nextGlitch - dt
	if (nextGlitch < 0) then
		logo_pause:play()
		nextGlitch = math.random(3,6)
	end
	creditX = (creditX - (dt * 200)) % credit:getWidth()
	logo_pause:update(dt)
end

function pause:draw()
	love.graphics.draw(menubg1, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 30) + 30)
	love.graphics.draw(menubg2, 0, 0, 0 , sx, sy)

	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 180) + 180)
	logo_pause:draw(0,0,0, sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 200) + 200)
	love.graphics.draw(resume,	posX_resume*sx,		posY_button * sy,0, sx, sy)
	love.graphics.draw(quit,		posX_quit*sx,		posY_button * sy,0, sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 180) + 180)
	love.graphics.draw(pausetext, creditX * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.draw(pausetext, (creditX - pausetext:getWidth()) * sx, 1344 * sy, 0 , sx, sy)

	love.graphics.setColor(255, 255, 255, 255)
end

function pause:mousepressed(x,y,button)
	x = x / sx
	y = y / sy
	print(x,y,button)
	if (x > posX_resume and x < (posX_resume + resume:getWidth()) and y > posY_button and y < (posY_button + resume:getHeight())) then
		sfx_start:play()
		bg_music_pause:stop()
		Gamestate.pop()
	end
	if (x > posX_quit and x < (posX_quit + quit:getWidth()) and y > posY_button and y < (posY_button + quit:getHeight())) then
		sfx_start:play()
		bg_music_pause:stop()
		Gamestate.pop("quit")
	 end
end

function pause:keypressed(key)
	print(key)
	if (key == 'escape') then
		sfx_start:play()
		bg_music_pause:stop()
		Gamestate.pop()
	end
end
