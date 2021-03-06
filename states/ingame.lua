-- warbrick (c) 2013 <weldale@gmail.com>

InGame = GameState:subclass("states.InGame")

function InGame:getName()
  return "ingame"
end

function InGame:load()
  self.tileset = Tileset:new("assets/tiles.lua")
end

function InGame:createViewportFor( e, w, h )
  return Viewport:new( 
    area( e.vC.x - w/2, e.vC.y - h/2, w, h ), 
    self.map, self.tileset, 
    { followSelector = e:getFollowFunction(), scrollBorder = -1 } 
    )
end

function InGame:createGlobalViewport( w, h )
  return Viewport:new(
    area( 0, 0, w, h ),
    self.map,
    self.tileset
    )
end


function InGame:onStateChange(oldState, params)
  if not oldState or oldState == "ingame" or oldState == "gameover" or oldState == "mainmenu" then
    
    self.endGame = false
    self.fadeOutTime = 1
    
    self.startParams = params
    
    self.map = Map:new(params.mapid)
    self.players = {}
    
    gameManager = GameManager:new( self.map, self.players )
    
    for i = 1, params.numPlayers do
      gameManager:newPlayer( i )
    end
    
    self.gui = Gui:new()
    
    self.viewContainer = ViewContainer:new()
    self.viewContainer.backgroundColor = {32,74,135}
    
    self.viewportContainer = ViewContainer:new( 675, 585 )

	--self.bbox = area( 0, 0, 1350, 1170 )
  
    self.viewports = {}
  
    if self.map.def.settings.viewport == "global" then
      local vp = self:createGlobalViewport( 675, 585 )
      
      table.insert( self.viewports, vp )
      self.viewportContainer:add( "vpg", vp, 0, 0, 0, 675, 585 )
    elseif self.map.def.settings.viewport == "single" then
      
      for i,v in ipairs(self.players) do
        local vp = self:createViewportFor(v, 327, 282 )
        table.insert(self.viewports, vp )
        
        local row = math.floor((i-1)/2)
        local col = math.floor((i-1)%2)
        
        self.viewportContainer:add( "vp" .. i, vp, 337 * col, 292 * row, 0, 327, 282 )
        
      end
      
    end
    	
    
    self.viewContainer:add( "viewports", self.viewportContainer, 10, 7, 0, 675, 585 )
    
    self.viewContainer:add( "gui", self.gui, 700, 7, 0, 95, 585 )
  end
  
  return true
end


function InGame:draw()
  self.viewContainer:draw()
end

function InGame:update(dt)

--[[
  local minX, minY, maxX, maxY = self.bbox:getPoints()
  minX = (maxX + minX) / 2
  maxX = minX
  minY = (maxY + minY) / 2
  maxY = minY

  for i,p in ipairs(self.players) do
    if p.vC.x < minX then
      minX = p.vC.x
    end
      if p.vC.x > maxX then
      maxX = p.vC.x
    end
      if p.vC.y < minY then
      minY = p.vC.y
    end
      if p.vC.y > maxY then
      maxY = p.vC.y
    end
  end
  
  self.bbox:setPoints( minX - 90, minY - 90, maxX + 90, maxY + 90 )
  ]]

  for i,vp in ipairs(self.viewports) do
    vp:update(dt)
  end
  
  self.map:update(dt)
  
  local livingPlayers = self.map:findEntities( ffAnd( ffPlayers, function(e) return e.lives > 0 end) )
  if #livingPlayers <= 1 then
    gameStateManager:change( "gameover", { players = self.players, winPlayer = livingPlayers[1], startParams = self.startParams })
  end
  
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