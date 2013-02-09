-- geolib.lua (c) 2013 <weldale@gmail.com>

Vector = class("Vector")

function v2(x, y)
  return Vector:new(x,y)
end

function Vector2D:initialize( x, y )
  
  self.x = x
  self.y = y
  
end

function Vector2D:dst( o )
  
end

function Vector2D:dstsq( o )
  
end

