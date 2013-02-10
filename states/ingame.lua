-- warbrick (c) 2013 <weldale@gmail.com>

InGame = GameState:subclass("states.InGame")

function InGame:getName()
  return "ingame"
end

function InGame:load()
  self.tileset = Tileset:new("assets/tiles.lua")
end

function InGame:onStateChange(oldState, mapId, ...)
  if not oldState then
    self.map = Map:new(mapId)
    
    self.players = {
      Player:new( v2( 36, 30 ), 1 ),
      Player:new( v2( 36, 30 ), 2 ),
      Player:new( v2( 36, 30 ), 3 ),
      Player:new( v2( 36, 30 ), 4 )
    }
    
    self.map:addEntity( self.players[1] )
    self.map:addEntity( self.players[2] )
    self.map:addEntity( self.players[3] )
    self.map:addEntity( self.players[4] )
    
    self.viewContainer = ViewContainer:new()
    self.viewContainer.backgroundColor = {32,74,135}
    
    self.viewportContainer = ViewContainer:new( 675, 585 )
    
    self.viewports = {
      Viewport:new( area( 0, 0, 327, 282 ), self.map, self.tileset, { followSelector = self.players[1]:getFollowFunction() } ),
      Viewport:new( area( 0, 0, 327, 282 ), self.map, self.tileset, { followSelector = self.players[2]:getFollowFunction() } ),
      Viewport:new( area( 0, 0, 327, 282 ), self.map, self.tileset, { followSelector = self.players[3]:getFollowFunction() } ),
      Viewport:new( area( 0, 0, 327, 282 ), self.map, self.tileset, { followSelector = self.players[4]:getFollowFunction() } )
    }
    
    self.viewportContainer:add( "vp1", self.viewports[1], 0, 0, 0, 327, 282 )
    self.viewportContainer:add( "vp2", self.viewports[2], 337, 0, 0, 327, 282 )
    self.viewportContainer:add( "vp3", self.viewports[3], 0, 292, 0, 327, 282 )
    self.viewportContainer:add( "vp4", self.viewports[4], 337, 292, 0, 327, 282 )
    
    self.viewContainer:add( "viewports", self.viewportContainer, 10, 7, 0, 675, 585 )
  end
  
  return true
end


function InGame:draw()
  self.viewContainer:draw()
end

function InGame:update(dt)
  for i,vp in ipairs(self.viewports) do
    vp:update(dt)
  end
  
  self.map:update(dt)
end

function InGame:keypressed(key)
  for i,p in ipairs(self.players) do
    p:keypressed(key)
  end
end

function InGame:keyreleased(key)
  for i,p in ipairs(self.players) do
    p:keyreleased(key)
  end
end


return InGame