-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

Player = Entity:subclass("Player")

function Player:initialize( vO, number )
  Entity.initialize( self, vO )
  
  self.number = number
  
  self.goto = { up = false, down = false, left = false, right = false }
  
  self.graphics = assetManager:create("player" .. number)
  
  self.hitbox.left = 15
  self.hitbox.right = 15
  self.hitbox.top = 20
  self.hitbox.bottom = 20
  
  self.collectRadius = 50
  
  self.speed = 200
  
  self.selectedBrick = nil
  
  self.category.isPlayer = true
  
  self.score = 0
  self.lives = 3
end

function Player:stop()
	self:stopWalk()
	
	self.goto = { up = false, down = false, left = false, right = false }
	Entity.stop(self)
end

function Player:keypressed(key)
    if util.keycheck(key, keyconfig.player[self.number].left) then
        self.goto.left = true
		self:startWalk()
    elseif util.keycheck(key, keyconfig.player[self.number].right) then
        self.goto.right = true
		self:startWalk()
    elseif util.keycheck(key, keyconfig.player[self.number].up) then
        self.goto.up = true
		self:startWalk()
    elseif util.keycheck(key, keyconfig.player[self.number].down) then
        self.goto.down = true
		self:startWalk()
    end
    
	if self.goto.up then
		self.vD.y = -1
	elseif self.goto.down then
		self.vD.y = 1
	else
		self.vD.y = 0
	end

	if self.goto.left then
		self.vD.x = -1
	elseif self.goto.right then
		self.vD.x = 1
	else
		self.vD.x = 0
	end
  
  if util.keycheck(key, keyconfig.player[self.number].action) then
    self:doAction()
  end
  
end

function Player:keyreleased(key)
  if util.keycheck(key,keyconfig.player[self.number].left) then
		self.goto.left = false
	elseif util.keycheck(key,keyconfig.player[self.number].right) then
    self.goto.right = false
  elseif util.keycheck(key,keyconfig.player[self.number].up) then
		self.goto.up = false
	elseif util.keycheck(key,keyconfig.player[self.number].down) then
    self.goto.down = false
  end
	
	if not self.goto.up and not self.goto.down and not self.goto.left and not self.goto.right then
		self:stopWalk()
	end
	
	if self.goto.up then
		self.vD.y = -1
	elseif self.goto.down then
		self.vD.y = 1
	else
		self.vD.y = 0
	end

	if self.goto.left then
		self.vD.x = -1
	elseif self.goto.right then
		self.vD.x = 1
	else
		self.vD.x = 0
	end
end

function Player:doAction()
  
  if self.selectedBrick then
    self.selectedBrick:setSelected(false)
    self.selectedBrick:attach(self)
    
    self.carryingBrick = self.selectedBrick
    self.selectedBrick = nil
    
  elseif self.carryingBrick then
    self.carryingBrick:deattach(self)
    self.carryingBrick = nil
  end
  
end

function Player:startWalk()
end

function Player:stopWalk()
end

function Player:_selectBricks()
  
  local bricks = gameManager:findEntities( 
    function(e) 
      return 
        e.category.isBrick 
        and not e.attachedAt
        and self.vC:dstsq( e.vC ) <= self.collectRadius * self.collectRadius
    end
  )
  
  if #bricks > 0 then
    
    local minBrick = bricks[1]
    local min = self.vC:dstsq( minBrick.vC )
    
    for i = 2, #bricks do
      local b = bricks[i]
      local dst = self.vC:dstsq( b.vC ) 
    
      if dst < min then
        minBrick = b
        min = dst
      end 
    end
    
    if self.selectedBrick then
      self.selectedBrick:setSelected(false)
    end
    
    self.selectedBrick = minBrick
    self.selectedBrick:setSelected(true)
  else
    
    if self.selectedBrick then
      self.selectedBrick:setSelected(false)
    end
    self.selectedBrick = nil
  end
end



function Player:update(dt)
  
  if self.lives == 0 then return end
  
  if not self.carryingBrick then
    self:_selectBricks()
  end
  
  Entity.update( self, dt )
end

function Player:draw()
  Entity.draw(self)
  
  --love.graphics.circle( "line", self.vC.x, self.vC.y, self.collectRadius )
end

function Player:hit()
  
  self.graphics.tintOverride = {255,0,0}
  
  self:addTimer( "nored", 1, function() self.graphics.tintOverride = nil end )
    
  self.lives = self.lives - 1
  
end


