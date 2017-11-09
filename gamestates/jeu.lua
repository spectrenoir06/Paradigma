jeu = {}
local Gamestate = require 'lib/gamestate'
local class = require 'lib/middleclass'
local Game = require "class/Game"

function jeu:init()

	game = Game:new()
	fullscreen = false
end

function jeu:enter()
	game:enter()
end

function jeu:resume(prev,str1)
	print("jeu resume",str1)
	if str1 == "quit" then
		Gamestate.switch(menu)
	else
		game:resume()
	end
end

function jeu:leave()
	game:leave()
end

function jeu:update(dt)
	game:update(dt)
end

function jeu:draw()
	game:draw()
end

function jeu:keypressed(key)
	--print("jeu",key)
	game:keypressed(key)
end

function jeu:mousepressed(x, y, button)
	-- print("jeu",x,y,button)
	game:mousepressed(x, y, button)
end

function jeu:mousereleased(x, y, button)
	-- print("jeu",x,y,button)
	game:mousereleased(x, y, button)
end
