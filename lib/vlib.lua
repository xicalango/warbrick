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

  function Vector2D:get( idx )
    if idx == 1 then
      return self.x
    elseif idx == 2 then
      return self.y
    else
      error("idx must lie between 1 and 2")
    end
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

function Vector2D:ratio()
  return self.x / self.y
end

Area = class("Area")

function Area:initialize( vTopLeft, vSize )
  self.vTL = vTopLeft or v2(0,0)
  self.vSize = vSize w or v2(0,0)  
end

function Area:move( vDispl )
  self.vTL = self.vTL + vDispl
end

function Area:getRatio()
  return vSize:ratio()
end

function Area:scale( f )
  self.vSize = self.vSize * f
end

function Area:map( area, vDst )
    return v2(
      (area.vSize.x / self.vSize.x) * (vDst.x - self.vTL.x) + area.vTL.x,
      (area.vSize.y / self.vSize.y) * (vDst.y - self.VTL.y) + area.vTL.y
      )
end

function Area:getLowerRight()
  return vO + vSize
end

function Area:pointInArea( vQ ) 
    return vQ.x >= self.vO.x and
           vQ.x <= self.vO.x+self.vSize.x and
           vQ.y >= self.vO.y and
           vQ.y <= self.vO.y+self.vSize.y
end

