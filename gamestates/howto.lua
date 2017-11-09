howto = {}
local class		= require 'lib/middleclass'
local Gamestate	= require 'lib/gamestate'
local Sprite	= require 'lib/sprite'


function howto:enter()
	--bg_music_howto:play()
	time = 0
	creditX = 0

end

function howto:init()
	howtotext = love.graphics.newImage("media/texture/howtotexte.png")
	logo_howto = love.graphics.newImage("media/texture/howto.png")
end

function howto:update(dt)
	time = time + dt
	creditX = (creditX - (dt * 200)) % howtotext:getWidth()
end

function howto:draw()
	love.graphics.draw(menubg1, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 30) + 30)
	love.graphics.draw(menubg2, 0, 0, 0 , sx, sy)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(logo_howto,0,70 * sy,0, sx, sy)

	love.graphics.draw(howtotext, creditX * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.draw(howtotext, (creditX - howtotext:getWidth()) * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, 255)
end

function howto:mousepressed(x,y,button)
	x = x / sx
	y = y / sy
	--print(x,y,button)
	menu_bg_music:stop()
	Gamestate.switch(jeu)
end

function howto:keypressed(key)
	--print(key)
	if (key == 'escape') then
		menu_bg_music:stop()
		Gamestate.switch(menu)
	elseif (key == ' ') then
		menu_bg_music:stop()
		Gamestate.switch(jeu)
	end
end
