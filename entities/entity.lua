-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

Entity = class("Entity")

function Entity:initialize( v0, z )
  self.vC = v0 or v2(0,0)
  
  self.z = z or 1
  
  self.speed = 100
  
  self.vD = v2(0,0)
  
  self.friction = 0
  
  self.onMap = true
  
  self.hitbox = { left = 0, right = 0, top = 0, bottom = 0 }
  
  self.timers = {}
  
  self.category = {
    isPlayer = false,
    isBrick = false
  }
  
  self.attachedAt = nil

end

function Entity:getFollowFunction()
  return function() return self.vC end
end

function Entity:attachAt( e, ox, oy )
  if not e then
    self.attachedAt = nil
    return
  end
  
  self.attachedAt = { entity = e, offset = {ox or 0, oy or 0} }
end


function Entity:addTimer( name, time, callback, unit )
	self.timers[name] = {
		name = name,
		time = time,
		unit = unit or "s",
		callback = callback,
		enabled = true
	}
end

function Entity:removeTimer( name )
	self.timers[name] = nil
end

function Entity:setTimerEnabled( name, value )
	if self.timers[name] == nil then return end
	
	self.timers[name].enabled = value
end

function Entity:isMoving()
  return self.vD.x ~= 0 or self.vD.y ~= 0
end

function Entity:_move(dt)
  
  if self.attachedAt then
    self.vC.x = self.attachedAt.entity.vC.x + self.attachedAt.offset[1]
    self.vC.y = self.attachedAt.entity.vC.y + self.attachedAt.offset[2]
  else
    if self:isMoving() then
      self.vD.x = self.vD.x * (1 - self.friction * dt)
      self.vD.y = self.vD.y * (1 - self.friction * dt)
      
      if self.vD:normsq() < 0.01 then 
        self:stop()
        return
      end
      
      
      local oldX = self.vC.x
      local oldY = self.vC.y
    
      local newX = self.vC.x + self.vD.x * (self.speed * dt)
      local newY = self.vC.y + self.vD.y * (self.speed * dt)
    
      self.vC.x = newX
      self.vC.y = newY
      
      local wallTest, e = gameManager:isWallForEntity( self )
      
      if wallTest then
        self:onCollide(e)
        self.vC.x = oldX
        
        if gameManager:isWallForEntity( self ) then
          self.vC.x = newX
          self.vC.y = oldY
          
          if gameManager:isWallForEntity( self ) then
            self.vC.x = oldX
            self.vC.y = oldY
          end
          
        end
        
      end
      
    end

  end
  
end


function Entity:update(dt)
  
  self:_move(dt)
	
	for k,v in pairs(self.timers) do
		if v.unit == "s" then
			v.time = v.time - dt
		elseif v.unit == "t" then
			v.time = v.time - 1
		end
		
		if v.time <= 0 then
			if v.callback ~= nil then
				local newTime = v.callback(self)
				if not newTime then --remove timer
					self.timers[k] = nil
				else
					v.time = newTime
				end
			else
				self.timers[k] = nil
			end
		end
		
	end
  
  if self.graphics then
    self.graphics:update(dt)
  end
  
end

function Entity:blocks( e )
  return false
end

function Entity:collides( x, y )
	return x >= self.vC.x - self.hitbox.left and x <= self.vC.x + self.hitbox.right and y >= self.vC.y - self.hitbox.top and y <= self.vC.y + self.hitbox.bottom
end

function Entity:collidesEntity( e2 )
  
  local sr11, sr12, sr21, sr22 = self:fastGetHitRectangle()
  local er11, er12, er21, er22 = e2:fastGetHitRectangle()
  
  return fastRectangleIntersectTest( 
    sr11, sr12, sr21, sr22,
    er11, er12, er21, er22
  )
end

function Entity:fastGetHitRectangle()
  return 
    self.vC.x - self.hitbox.left,
    self.vC.y - self.hitbox.top,
    self.vC.x + self.hitbox.right,
    self.vC.y + self.hitbox.bottom
end

function Entity:isWall( x, y )
  return gameManager:isWall( x, y )
end

function Entity:draw()
  if self.graphics then
    self.graphics:draw( self.vC )
    --love.graphics.circle("line", self.vC.x, self.vC.y, 5)
  end
end

function Entity:stop()
  self.vD.x = 0
  self.vD.y = 0
  self:onStop()
end

function Entity:removeFromMap()
    self.onMap = false
    self:onRemove()
end

function Entity:onRemove()
end

function Entity:onCollide( e )
end

function Entity:onMousePressed( button )
end

function Entity:onStop()
end

