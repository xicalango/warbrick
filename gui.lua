

Gui = class("Gui")

function Gui:draw()
  
  local vD = v2( 30, 20 )
  
  for i,p in ipairs(gameManager.players) do
    
    p.graphics:draw( vD )
    love.graphics.print( "Lives: " .. p.lives, vD.x, vD.y + 30 )
    
    vD.y = vD.y + 100
    
  end
  
  
end

