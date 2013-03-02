-- warbrick (c) 2013 <weldale@gmail.com>

require("lib/middleclass")
require("lib/vlib")
require("lib/dynamicLoader")
require("lib/util")
require("lib/rng")
require("lib/gamestate")
require("lib/graphics")
require("lib/graphicsPreloader")
require("lib/assetManager")
require("lib/viewContainer")
require("lib/tileset")
require("lib/viewport")

require("entities/entity")
require("entities/player")
require("entities/brick")

require("gameManager")

require("map")
require("gui")

require("keyconfig")

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  debug = true
  
  startTime = love.timer.getMicroTime( )
  
  local graphicsPreloader = GraphicsPreloader:new("assets")
  graphicsPreloader:loadFile("graphics.lua")
  
  assetManager = AssetManager:new("assets")
  assetManager.graphicsPreloader = graphicsPreloader
  assetManager:loadFolder()  
  
  gameStateManager = GameStateManager:new()
  gameStateManager:loadFolder( "states" )
  gameStateManager:change( "ingame", {mapid = "level1_4", numPlayers = 4} )
end

function love.draw()
  gameStateManager:draw()
end

function love.update(dt)
  gameStateManager:update(dt)
end

function love.keypressed(key)

  if key == "f12" then
		love.event.push("quit")
    return
  elseif key == "f11" then
    gameStateManager:change( "ingame", {mapid = "level2", numPlayers = 4} )
    return
  elseif key == "f5" then
    love.graphics.toggleFullscreen()
    return
	end
    
  gameStateManager:keypressed(key)
    
end

function love.keyreleased(key)
    gameStateManager:keyreleased(key)
end

function love.mousepressed(x, y, button)
    gameStateManager:mousepressed(x,y,button)
end

function love.mousereleased(x, y, button)
    gameStateManager:mousereleased(x,y,button)
end
