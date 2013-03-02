-- warbrick (c) 2013 <weldale@gmail.com>

MainMenu = GameState:subclass("states.MainMenu")

function MainMenu:getName()
  return "mainmenu"
end

function MainMenu:load()
  
  self.viewContainer = ViewContainer:new()
  self.viewContainer.borderColor = {255,255,255,255}
  self.mainMenu = Menu:new( nil, 400, 200 )
  
  self.mainMenu:addItem( "test", "Test" )
  self.mainMenu:addItem( "test2" )
  
  self.viewContainer:add( "mainMenu", self.mainMenu, 200, 100, 0, 400, 200 )
  
end

function MainMenu:onStateChange(oldState, params)
  return true
end


function MainMenu:draw()
  
  self.viewContainer:draw()

end

function MainMenu:keypressed( key )
end
  


return MainMenu