-- tileset (c) 2013 <weldale@gmail.com>

Tileset = class("Tileset")

function Tileset:initialize( tilesetFile )
  
  local chunk = love.filesystem.load( tilesetFile )
	self.def = chunk()
  
  self.tileWidth = self.def.size[1]
  self.tileHeight = self.def.size[2] or self.tileWidth
  
  self.image = love.graphics.newImage(self.def.imagePath)
  
  local imageWidth = self.image:getWidth()
  local imageHeight = self.image:getHeight()
  
  self.tilesX = math.floor(imageWidth/self.tileWidth)
  self.tilesY = math.floor(imageHeight/self.tileHeight)
  
  self.quads = {}
    
  for y = 0, self.tilesY - 1 do
      for x = 0, self.tilesX - 1 do
          self.quads[y * self.tilesX + x] = love.graphics.newQuad(
              x * self.tileWidth, y * self.tileHeight, 
              self.tileWidth, self.tileHeight, 
              imageWidth, imageHeight
          )
      end
  end 
  
end

function Tileset:map( char )
  return self.def.tileMapping[char]
end

Tilemap = class("Tilemap")

function Tilemap:initialize( tileset, vSize )
  
  self.tileset = tileset
  
  self.vSize = vSize or v2( love.graphics.getWidth(), love.graphics.getHeight() )
  
  self.maxTilesX = math.floor((self.vSize.x/self.tileset.tileWidth))+1
  self.maxTilesY = math.floor((self.vSize.y/self.tileset.tileHeight))+1
  
  self.batch = love.graphics.newSpriteBatch( tileset.image, (self.maxTilesX+1) * (self.maxTilesY+1) )

end

function Tilemap:updateFocus(vDest, map)
    self.batch:clear()
    
    local tiles = map.map
    
    local mapShiftX = math.floor(vDest.x / self.tileset.tileWidth)
    local mapShiftY = math.floor(vDest.y / self.tileset.tileHeight)
    
    for x = 0, self.maxTilesX do
        for y = 0, self.maxTilesY do
            
            local xx = x + mapShiftX + 1
            local yy = y + mapShiftY + 1
            
            if yy >= 1 and yy <= map.height and xx >= 1 and xx <= map.width then
              local tileId = self.tileset:map(tiles[yy][xx])
             
              if tileId then
                self.batch:addq( 
                  self.tileset.quads[ tileId ], 
                  x * self.tileset.tileWidth, y * self.tileset.tileHeight
                )
              end
            end
        end
    end
    
end

function Tilemap:draw(vDest)
      
  local mapShiftX = vDest.x / self.tileset.tileWidth
  local mapShiftY = vDest.y / self.tileset.tileHeight
  
  love.graphics.draw(self.batch, 
    math.floor(-(mapShiftX%1) * self.tileset.tileWidth), 
    math.floor(-(mapShiftY%1) * self.tileset.tileHeight)
  )
end
