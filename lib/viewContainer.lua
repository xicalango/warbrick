-- ViewContainer (c) 2013 <weldale@gmail.com>

ViewContainer = class("ViewContainer")

ViewContainer.static.zSort = function( c1, c2 )
  return c1.z > c2.z
end


function ViewContainer:initialize( w, h )
  self.components = {}
  
  self.width = w or love.graphics.getWidth()
  self.height = h or love.graphics.getHeight()
  
  self.backgroundColor = {0,0,0,0}
end

function ViewContainer:add( id, component, x, y, z )
  
  self.components[id] = {
    id = id,
    x = x,
    y = y,
    z = z or 0,
    visible = true,
    component = component
    }
  
end

function ViewContainer:draw()
  
  util.preserveColor(function()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill",0,0, self.width, self.height)
  end)
  
  local drawComponents = {}
  
  for k,v in pairs(self.components) do
    if v.visible then
      table.insert(drawComponents, v)
    end
  end
  
  table.sort(drawComponents, ViewContainer.static._zSort)
  
  for i,v in ipairs(drawComponents) do
    love.graphics.push()
    love.graphics.translate(v.x, v.y)
    
    v.component:draw()
    
    love.graphics.pop()
  end
  
  
end


