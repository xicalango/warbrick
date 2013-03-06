
BrickBomb = Brick:subclass("BrickBomb")

function BrickBomb:initialize( v0 )
  Brick.initialize( self, v0 )
  
  self.graphics = assetManager:create("brickBomb")

  self.radius = 100
  self.power = 500
  
  self.exploding = false

end

function BrickBomb:explode()
  local bricks = gameManager:findEntities( 
    function(e) 
      return 
        e ~= self
        and e.category.isBrick 
        and e:selectable()
        and self.vC:dstsq( e.vC ) <= self.radius * self.radius
    end
  )
  
  for i,v in ipairs(bricks) do
    v.vD:set( v.vC.x - self.vC.x, v.vC.y - self.vC.y )
    v.vD:normalize()
    
    v.speed = self.power
  end
  
  local players = gameManager:findEntities( 
    function(e) 
      return 
        e.category.isPlayer
        and self.vC:dstsq( e.vC ) <= self.radius * self.radius
    end
  )
  
  for i,v in ipairs(players) do
    v:hit()
  end
  
  
  
  self:removeFromMap()
end


function BrickBomb:onBrickCollide( ee, wasKicked )
 
  if self.exploding then
    return
  end
  
  self.exploding = true
 
  self:addAnimation{
    name = "explode",
    startValue = 0,
    endValue = 255,
    time = 1,
    actionCallback = function(e, value) 
      self.graphics.tintOverride = {255, 255-value, 255-value, 255}
      end,
    endCallback = function(e, value) self:explode() end
  } 
  
end
