-- warbrick (c) 2013 <weldale@gmail.com>

GraphicsPreloader = DynamicLoader:subclass("GraphicsPreloader")

function GraphicsPreloader:initialize( ... )
  DynamicLoader.initialize( self, ... )
  
  self.graphics = {}
end


function GraphicsPreloader:loadCallback( newGraphics )
  for k,v in pairs(newGraphics) do
    self.graphics[k] = love.graphics.newImage(v)
  end
end

function GraphicsPreloader:get(id)
  local realId = string.match(id, "%$%$*(.*)")
  
  return self.graphics[realId]
end
