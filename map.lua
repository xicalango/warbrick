-- warbrick (c) 2013 <weldale@gmail.com>

Map = class("Map")

Map.static.size = {15,13}

function Map:initialize()
  
  self.wall = assetManager:create("wallblock")
  self.clay = assetManager:create("clayblock")
  
  self.wallTileSize = self.wall:getSize()
  
  self.pageSize = {
    Map.static.size[1] * self.wallTileSize[1],
    Map.static.size[2] * self.wallTileSize[2]
  }
  
end

function Map:draw()
  
  util.preserveColor(function()
    love.graphics.setColor{138,226,52}
    love.graphics.rectangle("fill", 0, 0, self.pageSize[1], self.pageSize[2] )
  end)

  local dv = v2()
  
  for xx = 0, Map.static.size[1]-1 do
    self.wall:draw( dv )
    
    dv.y = self.wallTileSize[2] * (Map.static.size[2]-1)
    
    self.wall:draw( dv )
    
    dv:set(dv.x + self.wallTileSize[1], 0)
  end
  
  dv.x = 0
  dv.y = 0
  
  for yy = 0, Map.static.size[2]-1 do
    self.wall:draw( dv )
    
    dv.x = self.wallTileSize[1] * (Map.static.size[1]-1)
    
    self.wall:draw( dv )
    
    dv:set(0, dv.y + self.wallTileSize[2])
  end
  
  for xx = 1, Map.static.size[1]-2 do
    for yy = 1, Map.static.size[2]-2 do
      
      if xx % 2 == 0 and yy % 2 == 0 then
        
        self.clay:draw( v2(xx * self.wallTileSize[1], yy * self.wallTileSize[2]) )
        
      end
      
      
    end
  end
  
  
end
