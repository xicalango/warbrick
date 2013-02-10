-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

Player = Entity:subclass("Player")

function Player:initialize( vO, number )
  Entity.initialize( self, vO )
  
  self.number = number
  
  self.goto = { up = false, down = false, left = false, right = false }
  
  self.graphics = BoxGraphics{
    size = {30, 40},
    offset = {15, 20},
    mode = "fill",
    tint = {0, 255 * (number/4), 255 * (4-number/4)}
    }
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

function Player:startWalk()
end

function Player:stopWalk()
end

