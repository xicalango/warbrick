-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

Entity = class("Entity")

function Entity:initialize( v0 )
  self.vC = v0 or v2(0,0)
  
  self.speed = 100
  
  self.vD = v2(0,0)
  
  self.friction = 0
  
  self.onMap = true
  
  self.hitbox = { left = 0, right = 0, top = 0, bottom = 0 }
  
  self.timers = {}

end

function Entity:getFollowFunction()
  return function() return self.vC end
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

function Entity:update(dt)
	if self.dx ~= 0 or self.dy ~= 0 then
	  self.speed = self.speed * (1 - self.friction)
	
    local newX = self.vC.x + self.vD.x * (self.speed * dt)
    local newY = self.vC.y + self.vD.y * (self.speed * dt)
  
		if not self:isWall( newX, newY ) then
			self.vC.x = newX
			self.vC.y = newY
		elseif not self:isWall( newX, self.vC.y ) then
      self.vC.x = newX
    elseif not self:isWall( self.vC.x, newPos.y ) then
      self.vC.y = newY
    end
  end
	
	for k,v in pairs(self.timers) do
		if v.unit == "s" then
			v.time = v.time - dt
		elseif v.unit == "t" then
			v.time = v.time - 1
		end
		
		if v.time <= 0 then
			if v.callback ~= nil then
				local newTime = v.callback(self)
				if newTime == -1 then --remove timer
					self.timers[k] = nil
				else
					v.time = newTime
				end
			else
				self.timers[k] = nil
			end
		end
		
	end
  
end

function Entity:isWall( x, y )
  return false
end

function Entity:draw()
  if self.graphics then
    self.graphics:draw( self.vC )
  end
end

function Entity:stop()
  self.dx = 0
  self.dy = 0
end

function Entity:collide( vTest )
  
  return area( 
    self.vC.x - self.hitbox.left, 
    self.y - self.hitbox.top, 
    self.hitbox.left + self.hitbox.right,
    self.hitbox.top + self.hitbox.bottom
  ):pointInArea( vTest )

end

function Entity:removeFromMap()
    self.onMap = false
    self:onRemove()
end

function Entity:onRemove()
end

function Entity:onCollide( )
end

function Entity:onMousePressed( button )
end
