-- warbrick (c) 2013 <weldale@gmail.com>

local mapDefs = require("defs/maps")
local tileDefs = require("defs/tiles")

Map = class("Map")

function Map:initialize(mapName)
  
  self.def = mapDefs[mapName]
  assert(self.def, "Definition " .. mapName .. " does not exist")
  
  self.entities = {}
  
  self.entitiesZ = {}
  
  self:_buildMap()
  
  
end

function Map:_buildMap()
  self.width = self.def.size[1]
  self.height = self.def.size[2]
  
  self.map = {}
  self.mapInfo = {}
  
  self.startPositions = {}
  
  local bricks = {}
  
  for y = 1, self.height do
    local line = {}
    local infoLine = {}
    
    for x = 1, self.width do
      line[x] = string.sub( self.def.map[y], x, x )

      local def = tileDefs[line[x]]
      infoLine[x] = def
      
      if def.type == "brick" then
        table.insert(bricks, {self:mapPos( x, y )})
      elseif def.type == "startPos" then
        self.startPositions[def.playerNumber] = {self:mapPos( x, y )}
      end
	  
      if def.background then
        line[x] = def.background
      end
      
      if def.replaceDef then
        infoLine[x] = tileDefs[def.replaceDef]
      end
      
      local backgroundDef = tileDefs[line[x]]
      
      if backgroundDef and backgroundDef.shaded then
            
        if self.map[y-1][x] == backgroundDef.shaded[1] then
          line[x] = backgroundDef.shaded[2]
        end
            
      end
      
        
        
    end
    
    self.map[y] = line
    self.mapInfo[y] = infoLine
  end
  
  for i,b in ipairs(bricks) do
    self:addEntity( Brick:new( v2t(b) ) )
  end
  
  
end


function Map:isWall( x, y )
  local tileX, tileY = self:tilePos( x, y )
  
  return not self.mapInfo[tileY][tileX].walkable
end

function Map:isWallForEntity( e )
  local r1x, r1y, r2x, r2y = e:fastGetHitRectangle()

  if self:isWall(r1x,r1y) 
    or self:isWall(r2x,r1y) 
    or self:isWall(r1x,r2y) 
    or self:isWall(r2x,r2y) 
  then return true end
    
  for _,b in self:iFindEntities( function(ee) return ee ~= e and ee:blocks(e) end) do
    if e:collidesEntity(b) then return true, b end
  end
  
  return false
end


function Map:update(dt)
  
  for i,v in ipairs(self.entities) do
    local oldZ = v.z
    
    v:update(dt)
    
    if not v.onMap then
      table.remove(self.entities, i)
    else
      self:updateZ( v, oldZ )
    end
    
    
  end
  
end

function Map:updateZ( e, oldZ ) 
  if oldZ and self.entitiesZ[oldZ] then
    table.remove( self.entitiesZ[oldZ], util.getElementKey( self.entitiesZ[oldZ], e ) )
  end
  
  if not self.entitiesZ[e.z] then
    self.entitiesZ[e.z] = {}
  end
  
  table.insert(self.entitiesZ[e.z], e)
end


function Map:drawEntities(viewArea)  
  
  for _,t in ipairs(self.entitiesZ) do
    for i,v in ipairs(t) do
      if viewArea:fastIntersects( v:fastGetHitRectangle() ) then
        v:draw()
      end
    end
  end
  
end

function Map:tilePos( mapX, mapY )
  return math.floor(mapX/45)+1 , math.floor(mapY/45) +1
end


function Map:mapPos( tileX, tileY )
  return 22.5 + (tileX-1) * 45, 22.5 + (tileY-1) * 45
end

function Map:addEntity( e )
  table.insert(self.entities, e)
  
  self:updateZ( e )
end



function Map:findEntities( predicateFn )
  return util.filter( self.entities, predicateFn )
end

function Map:iFindEntities( predicateFn )
  return ipairs(self:findEntities(predicateFn))
end

function ffPlayers(e)
  return e.category.isPlayer
end

function ffBricks(e)
  return e.category.isBrick
end

function ffAnd(...)
  local predFns = {...}
  return function(e) 
    for _,f in ipairs(predFns) do
      if f(e) == false then return false end
    end
    return true
    end
end

function ffOr(...)
  local predFns = {...}
  return function(e) 
    for _,f in ipairs(predFns) do
      if f(e) == true then return true end
    end
    return false
    end
end
