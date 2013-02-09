-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>
-- (C) 2012 by Alexander Weld <alex.weld@gmx.net>
-- Changed to use middleclass

--- Baseclass for GameStates
GameState = class("GameState")

function GameState:getName()
  return "__NONE__"
end

function GameState:load()
end

function GameState:onActivation()
end

function GameState:onDeactivation()
end

function GameState:onStateChange(oldState)
  return true
end

function GameState:update(dt)
end

function GameState:draw()
end

function GameState:keypressed(key)
end

function GameState:keyreleased(key)
end

function GameState:mousepressed(x, y, button)
end

function GameState:mousereleased(x, y, button)
end

GameStateManager = DynamicLoader:subclass("GameStateManager")

function GameStateManager:initialize()
    self.states = {}
    self.currentState = GameState:new()
    
	self.frames = 0
end

function GameStateManager:registerFolder( folderName )
  self:loadFolder( folderName )
end

function GameStateManager:registerAll( statedefs )
    for i,statedef in ipairs(statedefs) do
        self:register( statedef )
    end
end

function GameStateManager:register( statedef )
    self.states[statedef:getName()] = statedef
    
    statedef:load()
end

function GameStateManager:loadCallback( statedef )
	self:register(statedef)
end

--[[
-- Schedule a state change to the state to the state given by name
-- State will be changed on next call to GameState:update
-- Calls onStateChange with the old state. When this method returns false, the state is not changed.
--]]
function GameStateManager:change( name )
    self.newState = name 
end

function GameStateManager:_changeState(name)
    self.currentState:onDeactivation()

    self.currentState = self.states[name]
    self.currentStateName = name

    self.currentState:onActivation()
end

function GameStateManager:_change()
    local name = self.newState
    self.newState = nil
    
    self.oldstate = self.currentStateName

    if self.states[name]:onStateChange(self.oldstate) then
      self:_changeState(name)
    end
end

function GameStateManager:foreignCall( statename, callfn, ... )
    pcall(self.states[statename][callfn], self.states[statename], ...)
end

function GameStateManager:update(dt)
    if self.newState ~= nil then
        self:_change()
    end
    
	self.frames = self.frames + 1
	
    self.currentState:update(dt)
end

function GameStateManager:draw()
    self.currentState:draw()
end

function GameStateManager:keypressed(key)
    self.currentState:keypressed(key)
end

function GameStateManager:keyreleased(key)
    self.currentState:keyreleased(key)
end

function GameStateManager:mousepressed(x, y, button)
    self.currentState:mousepressed(x,y,button)
end

function GameStateManager:mousereleased(x, y, button)
    self.currentState:mousereleased(x,y,button)
end
