-- warbrick (c) 2013 <weldale@gmail.com>

MainMenu = GameState:subclass("states.MainMenu")

local mapDefs = require("defs/maps")

function MainMenu:getName()
  return "mainmenu"
end

function MainMenu:_buildMainMenu()
  self.mainMenu = Menu:new( 405, 225, function(i, item) 
      if i then
        self:mainMenuSelect(item.id) 
      end
  end)
  self.mainMenu.font = love.graphics.newFont(30)
  self.mainMenu:addItem( "battleMode", "Battle Mode" )
  self.mainMenu:addItem( "fullScreen", "Toggle Fullscreen" )
  self.mainMenu:addItem( "quit", "Quit" )
  self.mainMenu:selectFirstItem()
end

function MainMenu:_buildMapSelectMenu()
  self.mapSelectMenu = Menu:new( 405, 225, function(i, item) 
      if not i then
        self:_changeMenu( "mainMenu" )
      else
        self:mapSelect( item.id )
      end
  end, function(i, item)
    if i then
      self.smallMapRenderer:setMap(mapDefs[item.id])
    else
      self.smallMapRenderer:setMap(nil)
    end
  end)

  self.mapSelectMenu.font = love.graphics.newFont(20)
  
  for k,_ in pairs(mapDefs) do
    self.mapSelectMenu:addItem( k )
  end
  
  self.mapSelectMenu:sort()
  self.mapSelectMenu:selectFirstItem()
end

function MainMenu:_buildPlayerSelectMenu()
    self.playerSelectMenu = Menu:new( 405, 225, function(i, item) 
      if not i then
        self:_changeMenu( "mapSelectMenu" )
      else
        self:playerSelect( item.id )
      end
    end)
  self.playerSelectMenu.font = love.graphics.newFont(30)
  for i = 2, 4 do
    self.playerSelectMenu:addItem( i, i .. " Players" )
  end
  self.playerSelectMenu:selectFirstItem()
end


function MainMenu:load()
  
  self.smallMapRenderer = SmallMapRenderer:new( 145 )
  
  self.view = ViewContainer:new()
  
  self.backgroundGraphics = assetManager:create("mainMenuBackground")
  
  self.menuContainer = ViewContainer:new(405, 225)
  
  self:_buildMainMenu()
  self:_buildMapSelectMenu()
  self:_buildPlayerSelectMenu()
  
  self.menus = { 
    mainMenu = self.mainMenu, 
    mapSelectMenu = self.mapSelectMenu,
    playerSelectMenu = self.playerSelectMenu
  }
  
  for k,v in pairs(self.menus) do
    self.menuContainer:add( k, v )
  end

  self.view:add( "menus", self.menuContainer, 200, 300, 0, 405, 225 )
  self.view:add( "smallMap", self.smallMapRenderer, 400, 350, 1, 145, 145 )

end

function MainMenu:playerSelect( playerStr ) 
  self.gameStartProperties.numPlayers = tonumber( playerStr )
  self:_startGame()
end


function MainMenu:mapSelect( mapId )
  self.gameStartProperties.map = mapId
  self:_changeMenu( "playerSelectMenu" )
end

function MainMenu:_changeMenu( newMenu )
  for k,v in pairs(self.menus) do
    self.menuContainer:setVisible( k, false)
  end
  
  self.menuContainer:setVisible( newMenu, true )
  self.currentMenu = self.menus[newMenu]
  
  self.smallMapRenderer:setMap(nil)
end

function MainMenu:mainMenuSelect( id )
  
  if id == "battleMode" then
    self.gameStartProperties.gameMode = "battle"
    self:_changeMenu( "mapSelectMenu" )
    self.mapSelectMenu:fireOnChange()
  elseif id == "fullScreen" then
    love.graphics.toggleFullscreen()
  elseif id == "quit" then
    love.event.push("quit")
  end
  
end

function MainMenu:_startGame()
    gameStateManager:change( "ingame", {mapid = self.gameStartProperties.map, numPlayers = self.gameStartProperties.numPlayers} )
end

function MainMenu:onStateChange(oldState, params)
  
  self.gameStartProperties = {
    gameMode = nil,
    map = nil,
    numPlayers = 2
  }
  
  self:_changeMenu( "mainMenu" )
  
  return true
end


function MainMenu:draw()
  
  self.backgroundGraphics:fastDraw( 0,0 )
  
  self.view:draw()

end

function MainMenu:keypressed( key )
  self.currentMenu:keypressed(key)
end
  


return MainMenu