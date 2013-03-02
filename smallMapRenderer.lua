-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

local tileDefs = require("defs/tiles")

SmallMapRenderer = class("SmallMapRenderer")

function SmallMapRenderer:initialize(size)
  self.size = size
  self.canvas = love.graphics.newCanvas( self.size, self.size )
end

function SmallMapRenderer:setMap(mapdef)
  if not mapdef then
    self.canvas:clear()
    return
  end
  
  local maxSize = math.max(mapdef.size[1], mapdef.size[2])
  
  self.tileSize = math.floor(self.size / maxSize)

  self:drawCanvas(mapdef)
end


function SmallMapRenderer:drawCanvas(mapdef)
  local parentCanvas = love.graphics.getCanvas()
  
  self.canvas:clear()
  love.graphics.setCanvas( self.canvas )
  
  for y = 1, mapdef.size[2] do
    for x = 1, mapdef.size[1] do
      local t = string.sub( mapdef.map[y], x, x )
      
      local def = tileDefs[t]
      
      util.preserveColor(function()
      
        if def.type == "brick" then
          love.graphics.setColor( 255, 255, 0, 255 )
        elseif def.type == "startPos" then
          love.graphics.setColor( 0, 255, 0, 255 )
        elseif def.type == "tile" and def.walkable then
          love.graphics.setColor( 0, 255, 255, 255 )
        elseif def.type == "tile" and not def.walkable then
          love.graphics.setColor( 127, 127, 127, 255 )
        end
        
        
        love.graphics.rectangle( "fill", (x-1) * self.tileSize, (y-1) * self.tileSize, self.tileSize, self.tileSize )
      end)

    end
    
  end
  
  love.graphics.setCanvas(parentCanvas)
end

function SmallMapRenderer:draw()

  love.graphics.draw( self.canvas, 0, 0 )
  
end

