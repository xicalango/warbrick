-- vlib.lua (c) 2013 <weldale@gmail.com>

Vector2D = class("Vector")

function v2(x, y)
  return Vector2D:new(x,y)
end

function v2t(t)
  if( t.x and t.y ) then
    return v2( t.x, t.y )
  end
  
  return v2( t[1], t[2] )
end

function Vector2D:initialize( x, y )
  self.x = x or 0
  self.y = y or 0
end

function Vector2D:__add( o )
  return v2( self.x + o.x, self.y + o.y )
end

function Vector2D:__sub( o )
  return v2( self.x - o.x, self.y - o.y )
end

function Vector2D:__mul( s )
  return v2( self.x * s, self.y * s )
end

function Vector2D:__tostring( )
  return "V2(" .. self.x .. ", " .. self.y .. ")"
end

function Vector2D:set( x, y )
  self.x = x
  self.y = y
end

function Vector2D:dst( o )
  return math.sqrt( self:dstsq( o ) )
end

function Vector2D:dstsq( o )
  local dx, dy = (o - self):getXY()
  return dx * dx + dy * dy
end

function Vector2D:angle( o )
  local dx, dy = (o - self):getXY()
  return math.atan2(dy,dx)
end

function Vector2D:getXY()
  return self.x, self.y
end

function Vector2D:clone()
  return v2t( self )
end

