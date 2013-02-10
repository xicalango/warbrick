-- ViewContainer (c) 2013 <weldale@gmail.com>

ViewContainer = class("ViewContainer")

ViewContainer.static._zSort = function( c1, c2 )
  return c1.z > c2.z
end


function ViewContainer:initialize( w, h )
  self.components = {}
  
  self.width = w or love.graphics.getWidth()
  self.height = h or love.graphics.getHeight()
  
  self.backgroundColor = {0,0,0,0}
end

function ViewContainer:add( id, component, x, y, z, w, h )
  
  self.components[id] = {
    id = id,
	canvas = love.graphics.newCanvas( w, h ),
    x = x or 0,
    y = y or 0,
    z = z or 0,
    w = w or self.width,
    h = h or self.height,
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
    local parentCanvas = love.graphics.getCanvas()
    
	v.canvas:clear()
    love.graphics.setCanvas( v.canvas )
    v.component:draw()
    love.graphics.setCanvas( parentCanvas )
    
    love.graphics.draw( v.canvas, v.x, v.y )
    
	--[[
    util.preserveColor(function()
        love.graphics.setColor{255,0,0}
        love.graphics.print( v.id, v.x + 5, v.y + 5 )
        love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
    end)
	]]
  end
  
  
end


