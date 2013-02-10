-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

Brick = Entity:subclass("Brick")

Brick.static.states = {
  ONGROUND = 0,
  CARRIED = 1,
  FLYING = 2,
  SLIDING = 3
}

function Brick:initialize( v0 )
  Entity.initialize( self, v0 )
  
  self.graphics = assetManager:create("standardBrick")
  
  self.hitbox.left = 17
  self.hitbox.right = 17
  self.hitbox.top = 17
  self.hitbox.bottom = 17
  
  self.category.isBrick = true
  
  self.selected = false
  self.state = Brick.static.states.ONGROUND
  
  self.friction = 1.5
  self.bouncieness = 0.1
  
  self.lastOwner = nil
  
end

function Brick:selectable()
  return self.state == Brick.static.states.ONGROUND
end

function Brick:attach( e )
  self:attachAt(e)
  self.state = Brick.static.states.CARRIED
  
  self.graphics.tintOverride = e.graphics.tint
end

function Brick:deattach( e )
  self:attachAt()
  
  self.lastOwner = e

  if e.vD:normsq() < 0.01 then
    self.state = Brick.static.states.ONGROUND
    self:setTint()
    return
  end
  
  self:applyPhysics( e.vD, e.speed + 300 )
  
  self:setTint()
end

function Brick:applyPhysics( vD, speed )
  self.vD.x = vD.x
  self.vD.y = vD.y
  self.speed = speed
  
  self.state = Brick.static.states.FLYING
end


function Brick:setSelected( state )
  self.selected = state
  self:setTint()
end

function Brick:setTint()
  if self.selected then
    self.graphics.tintOverride = {64, 255, 64}
  elseif self.lastOwner then
    self.graphics.tintOverride = self.lastOwner.graphics.tint
  else
    self.graphics.tintOverride = nil
  end
  
end


function Brick:onStop()
  Entity.onStop(self)
  self.state = Brick.static.states.ONGROUND
  self:setTint()
end

function Brick:update(dt)
  if self.gotHit then print(self.vC, self.vD) end
  
  if self.state == Brick.static.states.FLYING then
    for _,p in gameManager:iFindEntities( ffAnd( ffPlayers, function(e) return e ~= self.lastOwner end ) ) do
        if self:collidesEntity(p) then
          self:stop()
          p:stop()
          p:hit()
          self.lastOwner = p
          break
        end
    end
  
  end 
  
  Entity.update(self,dt)
end

function Brick:blocks(e)
  
  if e.category.isPlayer and e == self.lastOwner then 
    return false
  end
  
  if self.state == Brick.static.states.ONGROUND then return true end
  if self.state == Brick.static.states.CARRIED then return false end
  
  if self.state == Brick.static.states.FLYING then
    if e.category.isPlayer and e ~= self.lastOwner then 
      return true
    end
  end
  
  return false
  
end

function Brick:onCollide( e )
  
  if e and e.category.isBrick then
    e:applyPhysics( self.vD * (1-self.bouncieness), self.speed )
	self:applyPhysics( self.vD * -self.bouncieness, self.speed )
    --self:stop()
  end

end



