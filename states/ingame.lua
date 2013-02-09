-- warbrick (c) 2013 <weldale@gmail.com>

InGame = GameState:subclass("states.InGame")

function InGame:getName()
  return "ingame"
end

function InGame:load()
  self.map = Map:new()
  
  self.viewContainer = ViewContainer:new()
  self.viewContainer.backgroundColor = {32,74,135}
  self.viewContainer:add( "mapView", self.map, 10, 8 )
end

function InGame:draw()
  self.viewContainer:draw()
end

return InGame