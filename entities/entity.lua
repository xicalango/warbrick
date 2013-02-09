-- preakout (C) 2012 by Alexander Weld <alex.weld@gmx.net>

Entity = class("Entity")

Entity.static.TYPE = {
	NONE = 0,
	PLAYER = 1,
	MOB = 2,
	SHOT = 3,
	WEAPON = 4
}

function Entity:initialize( x, y )
  x = x or 0
  y = y or 0
  
  self.speed = 50
  
  self.x = x
  self.y = y
  
  self.dx = 0
  self.dy = 0
  
  self.friction = 0
  
  self.type = Entity.static.TYPE.NONE
  
  self.onMap = true
  
  self.hitbox = { left = 0, right = 0, top = 0, bottom = 0 }
  
  self.timers = {}

  self.attractedByPlayer = false
  self.followingPlayer = false

end

function Entity:setHitbox( left, right, top, bottom )
	self.hitbox.left = left
	self.hitbox.right = right
	self.hitbox.top = top
	self.hitbox.bottom = bottom
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

	if self.attractedByPlayer then
		if self.followingPlayer then
			self.dx, self.dy = util.normDir( self.x, self.y, state.player.x, state.player.y )
		else
			if util.dstsq( self.x, self.y, state.player.x, state.player.y ) < state.player.collectRad * state.player.collectRad  then
	            self.followingPlayer = true
	            self.friction = 0
	            self.speed = state.player.speed * 1.2
	        end
		end
	end

	if self.dx ~= 0 or self.dy ~= 0 then
	    self.speed = self.speed * (1 - self.friction)
	
		local newX = self.x + self.dx * self.speed * dt
		local newY = self.y + self.dy * self.speed * dt
		
		if not self:isWall( newX, newY ) then
			self.x = newX
			self.y = newY
		else
			if not self:isWall( newX, self.y ) then
				self.x = newX
			else
				if not self:isWall( self.x, newY ) then
					self.y = newY
				end
			end

			self:onCollide( "wall" )
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
	return state.map:isWall(x,y)
end

function Entity:draw()
  if self.graphics then
    self.graphics:draw( self.x, self.y )
  end
  
	--util.preserveColor( {255, 0, 0, 255}, function()
	--	love.graphics.rectangle( "line", self.x - self.hitbox.left, self.y - self.hitbox.top, self.hitbox.left + self.hitbox.right, self.hitbox.top + self.hitbox.bottom )
	--end)
end

function Entity:stop()
  self.dx = 0
  self.dy = 0
end

function Entity:collide( x, y )
	return x >= self.x - self.hitbox.left and x <= self.x + self.hitbox.right and y >= self.y - self.hitbox.top and y <= self.y + self.hitbox.bottom
end

function Entity:getPos()
	return self.x, self.y
end

function Entity:removeFromMap()
    self.onMap = false
    self:onRemove()
end

function Entity:onRemove()
end

function Entity:onCollide( t )
end

function Entity:onBulletHit( bullet )
	return false --doesn't interfer with bullets on standard
end

function Entity:onPlayerHit( player )
end

function Entity:onMousePressed( button )
end
