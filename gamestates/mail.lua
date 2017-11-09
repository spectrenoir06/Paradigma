mail = {}
local class		= require 'lib/middleclass'
local Gamestate	= require 'lib/gamestate'
local Sprite	= require 'lib/sprite'
local utf8 = require("utf8")

local sendmail	= require 'lib/sendemail'

smtp = require("socket")


	subject = "Paradigma - I Love Transmedia 2015"

	content = [[Bonjour,<br>
<br>
R&#233;alit&#233; virtuelle et hyper-r&#233;alit&#233; !<br>
<br>
Depuis les ann&#233;es 80, le fantasme de vivre dans une r&#233;alit&#233; virtuelle obs&#232;de l&#8217;homme.<br>
Parall&#232;lement, la soci&#233;t&#233; moderne entrem&#234;le au plus haut degr&#233; la technique avec nos vies. Sans le vouloir nous vivons dans une multiplicit&#233; de plans qui se rejoignent et se disjoignent.<br>
Comme tant de fois La r&#233;alit&#233; (virtuelle) d&#233;passe la fiction !<br>
<br>
Votre cartographie personnelle est jointe &#224; ce mail sous forme d'image.<br>
<br>
Cr&#233;dits team LE CORTEX (http://lecortex.com):<br>
<br>
Game design/Graphismes : Fr&#233;d&#233;ric Sommer<br>
Code : Antoine Dousssaud<br>
Musique/SFX : George Abitbol (https://soundcloud.com/george_abitbol-1)<br>
<br>
Musique du jeu en libre &#233;coute sur Soundcloud : https://soundcloud.com/george_abitbol-1/sets/paradigma<br>
<br>
I LOVE TRANSMEDIA, Game Jam<br>
<br>
24 heures pour r&#233;aliser un prototype de jeu vid&#233;o en &#233;quipe : un processus de fabrication &#224; d&#233;couvrir sur place.<br>
Durant la Nuit Blanche, six &#233;quipes, m&#234;lant d&#233;butants et confirm&#233;s, d&#233;veloppent leur jeu vid&#233;o dans l'enceinte de la Ga&#238;t&#233; lyrique. Aid&#233;s par des m&#233;diateurs, les spectateurs, joueurs ou curieux, sont invit&#233;s &#224; d&#233;couvrir le processus de cr&#233;ation d'un jeu vid&#233;o. Cette Game Jam cherche aussi &#224; abattre les cloisons entre les disciplines cr&#233;atives qui se rencontrent trop rarement. La jam se veut donc litt&#233;ralement transmedia, invitant des personnalit&#233;s d'univers cr&#233;atifs diff&#233;rents &#224; participer au d&#233;veloppement d'un jeu vid&#233;o.<br>
<br>
Voici en prime le sujet de la game jam 2015 :<br>
<br>
L&#8217;&#233;tiquette sur la cassette est devenue illisible, peluch&#233;e par ses t&#226;tonnements la nuit. Il y a tant d&#8217;autres chambres comme celle-ci.<br>
Depuis longtemps, il la pr&#233;f&#232;re silencieuse. Il ne se sert plus des perles audio jaunissantes. Il a appris chuchoter lui-meme tandis qu&#8217;il avance en acc&#233;l&#233;r&#233; travers les titres maladroits et les collines ondul&#233;es &#233;clair&#233;es par la lune d&#8217;un paysage qui n&#8217;est ni Hollywood, ni Rio, mais une approximation num&#233;rique &#233;dulcor&#233;e des deux. - Extrait de Lumi&#232;re virtuelle de William Gibson<br>
<br>
Merci d'avoir particip&#233;,<br>
Team LE CORTEX]]

function send_mail()
	param = {
		from = "paradigma@lecortex.com",
		to = input,
		server = {
			address = "mail.lecortex.com",
			port = 25,
			user = "paradigma@lecortex.com",
			password = "paradigma2015",
			ssl = false,
		},
		message = {
			subject = subject,
			html = content,
			file = {
				path =  love.filesystem.getSaveDirectory( ).."/"..save_screenshot
			}
		}
	}

	if input == "" then
		error_disp = true
		return
	end
	local result, err = sendmail(param)
	if result==1 then
		print("email send to :", input)
		Gamestate.pop()
	else
		print("email error:", input, err)
		error_disp = true
	end
end

function mail:enter()
	input = ""
	love.graphics.setFont(mail_font1)
	error_disp = false
	love.keyboard.setKeyRepeat(true)

end

function mail:init()

	mail_font1 = love.graphics.newFont("media/font/Megatron.otf", 38)

	--print("path",file.path)

	mailbg1 = love.graphics.newImage("media/texture/mailbg1.png")
	mailbg2 = love.graphics.newImage("media/texture/mailbg2.png")

	mailtext = love.graphics.newImage("media/texture/mailtexte.png")

	envoyermail = love.graphics.newImage("media/texture/envoyermail.png")
	erreurmail = love.graphics.newImage("media/texture/erreurmail.png")
	retourmail = love.graphics.newImage("media/texture/retourmail.png")

	creditX = 0

	nextGlitch = math.random(4,10)
	time = 0
end

function mail:update(dt)
	time = time + dt
	creditX = (creditX - (dt * 200)) % mailtext:getWidth()
end

function mail:draw()
	love.graphics.draw(mailbg1, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 30) + 30)
	love.graphics.draw(mailbg2, 0, 0, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, ((math.sin(time*8) + 1) / 2) * (255 - 180) + 180)
	-- logo:draw(0,0,0, sx, sy)
	love.graphics.draw(mailtext, creditX * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.draw(mailtext, (creditX - mailtext:getWidth()) * sx, 1344 * sy, 0 , sx, sy)
	love.graphics.setColor(255, 255, 255, 255)

	if error_disp then
		love.graphics.draw(erreurmail, 0, 428 * sy, 0 , sx, sy)
	end

	love.graphics.draw(envoyermail, 1930 * sx, 968 * sy, 0 , sx, sy)
	love.graphics.draw(retourmail, 422 * sx, 968 * sy, 0 , sx, sy)

	love.graphics.print(input,172*sy,580*sy,0,sx * 2, sx * 2)
end

function mail:mousepressed(x,y,button)
	x = x / sx
	y = y / sy
	print(x,y,button)


	if (	x > 1930 and
				x < (1930 + envoyermail:getWidth()) and
				y > 968 and
				y < (968 + envoyermail:getHeight())) then
		sfx_start:play()
		send_mail()
	end
	if (x > 422 and x < (422 + retourmail:getWidth()) and y > 968 and y < (968 + retourmail:getHeight())) then
		sfx_start:play()
		Gamestate.pop()
	end
end

function mail:keypressed(key)
	--print(key)
	--sfx_start:play()
	if key == "backspace" then
		-- get the byte offset to the last UTF-8 character in the string.
		local byteoffset = utf8.offset(input, -1)
		if byteoffset then
			-- remove the last UTF-8 character.
			-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(input, 1, -2).
			input = string.sub(input, 1, byteoffset - 1)
		end
	end
	if (key == "return") then
		send_mail()
	end
end

function mail:textinput(t)
		--print(t)
		input = input..t
end
