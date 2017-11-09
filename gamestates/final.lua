final = {}
local class		= require 'lib/middleclass'
local Gamestate	= require 'lib/gamestate'
local Sprite	= require 'lib/sprite'

require "lib/json"
local inspect = require "lib/inspect"

function spairs(t, order)
		-- collect the keys
		local keys = {}
		for k in pairs(t) do keys[#keys+1] = k end

		-- if order function given, sort by it by passing the table and keys a, b,
		-- otherwise just sort the keys
		if order then
				table.sort(keys, function(a,b) return order(t, a, b) end)
		else
				table.sort(keys)
		end

		-- return the iterator function
		local i = 0
		return function()
				i = i + 1
				if keys[i] then
						return keys[i], t[keys[i]]
				end
		end
end

function final:enter(prev, tab)
	stat = {}
	for k,v in spairs(tab, function(t,a,b) return t[b] < t[a] end) do
		table.insert(stat, {k,v})
	end
	points = {}

	print("stat:"..inspect(stat))

	for k,v in pairs(stat) do
		if (v[2] > 0) then
			table.insert(points, {x = (math.random(730,1222) * sx), y = (math.random(5,15) + (info[v[1]] * 171) * sy)})
		end
	end

	print("points:"..inspect(points))

	time = 0
	final_bg_music:play()
	love.graphics.setLineWidth( 5 )

	screenshot = false

end

function final:init()
	--print("arg", json.encode(arg))
	final_menubg	= love.graphics.newImage("media/texture/finalbg.png")
	final_grid		= love.graphics.newImage("media/texture/finalgrid.png")
	final_quit		= love.graphics.newImage("media/texture/quittefinal.png")
	final_mail		= love.graphics.newImage("media/texture/mail.png")
	point			= love.graphics.newImage("media/texture/point.png")
	pointmain		= love.graphics.newImage("media/texture/pointmain.png")

	final_bg_music = love.audio.newSource("media/music/final.ogg", "stream")
	final_bg_music:setLooping(true)

	final_click = love.audio.newSource("media/sfx/click.wav", "static")

	info = {
		art			= 0,
		tech		= 1,
		social		= 2,
		jeu			= 3,
		news		= 4,
		nature		= 5,
		spirit		= 6,
		}
end

function final:update(dt)
	time = time + dt
end

function final:draw()
	love.graphics.draw(final_menubg, 0, 0, 0 , sx, sy)
	love.graphics.draw(final_grid, 587 * sx, 33	* sy, 0 , sx, sy)
	love.graphics.draw(final_quit, 2174 * sx, 1099	* sy, 0 , sx, sy)
	love.graphics.draw(final_mail, 1505 * sx, 1099	* sy, 0 , sx, sy)

	for k,v in ipairs (points) do
		if (k > 1) then
			love.graphics.setColor( 255, 0, 0, 255 )
			love.graphics.line(v.x + ((point:getWidth() / 2) * sx), v.y + ((point:getHeight() / 2) * sy), points[1].x + ((pointmain:getWidth() / 2) * sx), points[1].y + ((pointmain:getHeight() / 2) * sy))
			love.graphics.setColor( 255, 255, 255, 255 )
		end
		if k==1 then
			love.graphics.draw(pointmain,v.x, v.y, 0 , sx, sy )
		else
			love.graphics.draw(point,v.x, v.y, 0 , sx, sy )
		end
	end

	if (not screenshot) then
		local scr = love.graphics.newScreenshot()
		print("screen")
		save_screenshot = (os.time()..'.png')
		scr:encode(save_screenshot)
		screenshot = true
	end
end

function final:mousepressed(x,y,button)
	x = x / sx
	y = y / sy
	print(x,y,button)
	if (x > 2174 and x < (2174 + final_quit:getWidth()) and y > 1099 and y < (1099 + final_quit:getHeight())) then
		final_bg_music:stop()
		sfx_start:play()
		Gamestate.switch(menu)
	end
	if (x > 1505 and x < (1505 + final_mail:getWidth()) and y > 1099 and y < (1099 + final_mail:getHeight())) then
		sfx_start:play()
		Gamestate.push(mail)
	end
end

function final:keypressed(key)
	if key == 'escape' then
		final_bg_music:stop()
		Gamestate.switch(menu)
	end
end
