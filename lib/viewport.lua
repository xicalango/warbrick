-- viewport (c) 2013 <weldale@gmail.com>

Viewport = class("Viewport")

function Viewport:initialize( viewArea, map, tileset, init )
  
  self.viewArea = viewArea
  self.map = map
  self.tilemap = Tilemap:new(tileset, viewArea.vSize)
  
  self.scrollBorder = 100
  self.followSelector = nil
  
  if init then
    self.scrollBorder = init.scrollBorder or self.scrollBorder
    self.followSelector = init.followSelector or self.followSelector
  end
end

function Viewport:inVP( v )
    return self.viewArea:pointInArea(v)
end

function Viewport:translate( vD )
    return vD - self.viewArea.vO
end

function Viewport:translateScreen( x, y ) 
    return vD + self.viewArea.vO
end

function Viewport:push()
    love.graphics.push()
    love.graphics.translate( -self.viewArea.vO.x, -self.viewArea.vO.y )
end

function Viewport:pop()
    love.graphics.pop()
end


function Viewport:draw()
    self.tilemap:draw(self.viewArea.vO)

    self:push()
    self.map:drawEntities(self.viewArea)
    self:pop()
end

function Viewport:update(dt)
  
  --print(self.viewArea)
  
  if self.followSelector then
    
    local vDest = self.followSelector()

    if vDest.x < self.viewArea.vO.x + self.scrollBorder then
        self.viewArea.vO.x = vDest.x - self.scrollBorder
    elseif vDest.x > self.viewArea.vO.x + self.viewArea.vSize.x - self.scrollBorder then
        self.viewArea.vO.x = vDest.x - (self.viewArea.vSize.x - self.scrollBorder)
    end

    if vDest.y < self.viewArea.vO.y + self.scrollBorder then
        self.viewArea.vO.y = vDest.y - self.scrollBorder
    elseif vDest.y > self.viewArea.vO.y + self.viewArea.vSize.y - self.scrollBorder then
        self.viewArea.vO.y = vDest.y - (self.viewArea.vSize.y - self.scrollBorder)
    end
    
  end
  
  if self.viewArea.vO.x < 0 then 
    self.viewArea.vO.x = 0 
  end
  
  if self.viewArea.vO.y < 0 then 
    self.viewArea.vO.y = 0 
  end
  
  local viewAreaLRx, viewAreaLRy = self.viewArea:getLowerRightXY()
  
  if viewAreaLRx >= self.map.width * self.tilemap.tileset.tileWidth then 
    self.viewArea.vO.x = self.map.width * self.tilemap.tileset.tileWidth - self.viewArea.vSize.x
  end
  
  if viewAreaLRy >= self.map.height * self.tilemap.tileset.tileHeight then 
    self.viewArea.vO.y = self.map.height * self.tilemap.tileset.tileHeight - self.viewArea.vSize.y
  end
  
  self.tilemap:updateFocus( self.viewArea.vO, self.map )
    
end
