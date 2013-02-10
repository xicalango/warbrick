-- warbrick (c) 2013 <weldale@gmail.com>

local mapDefs = require("defs/maps")
local tileDefs = require("defs/tiles")

Map = class("Map")

function Map:initialize(mapName)
  
  self.def = mapDefs[mapName]
  assert(self.def, "Definition " .. mapName .. " does not exist")
  
  self:_buildMap()
  
  self.entities = {}
  
end

function Map:_buildMap()
  self.width = self.def.size[1]
  self.height = self.def.size[2]
  
  self.map = {}
  self.mapInfo = {}
  
  for y = 1, self.height do
    local line = {}
    local infoLine = {}
    
    for x = 1, self.width do
      line[x] = string.sub( self.def.map[y], x, x )
      infoLine[x] = tileDefs[line[x]]
    end
    
    self.map[y] = line
    self.mapInfo[y] = infoLine
  end
  
end

function Map:update(dt)
  
  for i,v in ipairs(self.entities) do
    v:update(dt)
  end
  
end


function Map:drawEntities(viewArea)  
  
  for i,v in ipairs(self.entities) do
    
    if viewArea:pointInArea( v.vC ) then
      v:draw()
    end
    
  end
  
end

function Map:mapPos( tileX, tileY )
  return tileX * 45, tileY * 45
end

function Map:addEntity( e )
  table.insert(self.entities, e)
end
