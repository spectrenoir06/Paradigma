local Gamestate = require 'lib/gamestate'
require 'gamestates/jeu'
require 'gamestates/menu'
require 'gamestates/final'
require 'gamestates/pause'
require 'gamestates/howto'
require 'gamestates/mail'

love.window.setIcon( love.image.newImageData( "media/icone.png" ) )

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
