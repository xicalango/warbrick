-- warbrick (c) 2013 <weldale@gmail.com>

AbstractGraphics = class("AbstractGraphics")

function AbstractGraphics:initialize( init )
  
  self.offset = {0,0}
  self.scale =  {1}
  self.shearing =  {0,0}
  self.tint = nil
  self.rotationFn = nil
  
  if init then
    
    self.offset = init.offset or self.offset 
    self.scale = init.scale or self.scale 
    self.shearing = init.shearing or self.shearing 
    self.tint = init.tint or self.tint
    self.rotationFn = init.rotationFn or self.rotationFn
    
  end
  
end

function AbstractGraphics:getSize()
  return {0,0}
end

function AbstractGraphics:setMouseView()
  self.rotationFn = love.mouse.getPosition
end

function AbstractGraphics:draw( v2Coor, pars )
  local v2Dir = nil
  
  local tintOverride = nil
  local parPhi = nil
  
  if self.rotationFn then
		v2Dir = v2( self.rotationFn() )
	end
  
  if pars then
    v2Dir = pars.v2Dir or v2Dir
    tintOverride = pars.tintOverride or tintOverride
    parPhi = pars.phi or parPhi
  end
  
  local phi = math.rad(90)
  
  if parPhi then
    phi = parPhi
  elseif v2Dir then
    phi = v2Dir:angle(v2Coor) 
  end
  
  local xoff = v2Coor.x + self.offset[1]
  local yoff = v2Coor.y + self.offset[2]
  
  util.preserveColor( function()
      
      if tintOverride then
        love.graphics.setColor( tintOverride )
      elseif self.tint then
        love.graphics.setColor( self.tint )
      end
      
      self:_draw{
        
          [v2Coor] = v2Coor,
          x = v2Coor.x,
          y = v2Coor.y,
          [phi] = phi,
          xoff = xoff,
          yoff = yoff,
          sx = self.scale[1],
          sy = self.scale[2] or self.scale[1],
          ox = self.offset[1],
          oy = self.offset[2],
          kx = self.shearing[1],
          ky = self.shearing[2]
        }
    end)
  
end

function AbstractGraphics:update(dt)
end

Graphics = AbstractGraphics:subclass("Graphics")

function Graphics:initialize( init )
  AbstractGraphics.initialize( self, init )
  
  assert( init, "Graphics need image" )
  
  if string.match( init.image, "^%$+" ) and init.preloader then
    self.image = init.preloader:get(init.image)  
  else
    self.image = love.graphics.newImage( init.image )  
  end
  
end

function Graphics:_draw( i )
  love.graphics.draw( self.image, i.x, i.y, i.phi, i.sx, i.sy, i.ox, i.oy, i.kx, i.ky )
end

function Graphics:getSize()
  return {self.image:getWidth(), self.image:getHeight()}
end

AniGraphics = AbstractGraphics:subclass("AniGraphics")

function AniGraphics:initialize( init )
	AbstractGraphics.initialize( self, init )
    assert(init, "Initialization mandatory")

	self.anim = false
	self.frame = 0
	self.timer = 0
	self.viewName = ""
	self.view = {}
	self.quadDefs = {}
	self.quads = {}
  
  self.preloader = init.preloader or nil
  
	self:_loadViews(init.path)
end

function AniGraphics:_loadViews( path )
	local chunk = love.filesystem.load( path )
	self.def = chunk()
  
  if string.match( self.def.image, "^%$+" ) and self.preloader then
    self.image = init.preloader:get(self.def.image)  
  else
    self.image = love.graphics.newImage( self.def.image )  
  end
	
	local imageWidth, imageHeight = self.image:getWidth(), self.image:getHeight()
	
	for k,v in pairs(self.def.views) do
		local newQuads = {}
		
		for i = 1, v.frames do
			newQuads[i] = love.graphics.newQuad( 
				v.offset[1] + (i-1) * v.size[1],
				v.offset[2],
				v.size[1], v.size[2],
				imageWidth, imageHeight
				)
		end
		
		self.quadDefs[k] = newQuads
	end
	
	self:setView( "normal" )
end

function AniGraphics:setView(name, frame)
	self.viewName = name
	self.view = self.def.views[name]
	self.quads = self.quadDefs[name]
	
	self.anim = self.view.frames > 1
	self.frame = frame or 1
	
	if self.anim then
		self.timer = self.view.speed 
	end
end

function AniGraphics:update(dt)
	if self.anim then
		self.timer = self.timer - 1
		
		if self.timer <= 0 then
			self.frame = self.frame + 1
			self.timer = self.view.speed
			
			if self.frame > self.view.frames then
				if self.view.next then
					self:setView(self.view.next)
				else
					self.frame = 1
				end
			end
		end
	end
end

function AniGraphics:_draw( i )
	local quad = self.quads[self.frame]
	love.graphics.drawq( self.image, quad, i.x, i.y, i.phi, i.sx, i.sy, i.ox, i.oy, i.kx, i.ky )
end

function AniGraphics:getSize()
  --TODO implement!
  return AbstractGraphics.getSize(self)
end

BoxGraphics = AbstractGraphics:subclass("BoxGraphics")

function BoxGraphics:initialize( init )
  AbstractGraphics.initialize( self, init )
  
  self.mode = "line"
  self.size = {100, 100}
  
  if init then
    self.mode = init.mode or self.mode
    self.size = init.size or self.size
  end
   
end

function BoxGraphics:_draw( i )
  love.graphics.rectangle( self.mode, i.xoff, i.yoff, self.size[1] * i.sx, self.size[2] * i.sy )
end

function BoxGraphics:getSize()
  return self.size
end
