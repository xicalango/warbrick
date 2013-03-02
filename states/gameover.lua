-- warbrick (c) 2013 <weldale@gmail.com>

GameOver = GameState:subclass("states.GameOver")

function GameOver:getName()
  return "gameover"
end


function GameOver:onStateChange(oldState, params)
  if oldState == "ingame" then
    
    self.players = params.players
    self.winPlayer = params.winPlayer
    self.drawGame = params.winPlayer == nil
    self.startParams = params.startParams
    
  end
  
  return true
end


function GameOver:draw()
  
  if self.drawGame then
    love.graphics.print( "Draw Game", 400, 200 )
  else
    self.winPlayer.graphics:draw( v2(400, 200) )
    love.graphics.print( "Player " .. self.winPlayer.number .. " wins!", 400, 300 )
  end

  love.graphics.print( "To restart please press [Enter]", 400, 400 )
  love.graphics.print( "To return to main menu please press [ESC]", 400, 420 )

end

function GameOver:keypressed( key )
  if key == "return" then
    gameStateManager:change( "ingame", self.startParams )
  elseif key == "escape" then
    gameStateManager:change( "mainmenu" )
  end
end
  


return GameOver