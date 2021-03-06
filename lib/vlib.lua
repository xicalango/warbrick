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

function Vector2D:mul( s )
  self.x = self.x * s
  self.y = self.y * s
end

function Vector2D:__tostring( )
  return "V2(" .. self.x .. ", " .. self.y .. ")"
end

function Vector2D:scale( sx, sy )
  sx = sx or 1
  sy = sy or sx
  
  return v2( self.x * sx, self.y * sy )
end

function Vector2D:floor()
  return v2( math.floor(self.x), math.floor(self.y) )
end

function Vector2D:ceil()
  return v2( math.ceil(self.x), math.ceil(self.y) )
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

function Vector2D:normalize( )
  local norm = self:norm()
  
  if norm ~= 0 then
    self.x = self.x/norm
    self.y = self.y/norm
  end
end

function Vector2D:normsq( )
  return self.x * self.x + self.y * self.y
end

function Vector2D:norm( )
  return math.sqrt( self:normsq() )
end

function Vector2D:dst( o )
  return math.sqrt( self:dstsq( o ) )
end

function Vector2D:dstsq( o )
  return (o - self):normsq()
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

function area( x, y, w ,h )
  return Area:new( v2( x, y ), v2( w, h ) )
end

function Area:initialize( vTopLeft, vSize )
  self.vO = vTopLeft or v2(0,0)
  self.vSize = vSize or v2(0,0)  
end

function Area:__tostring()
  return "Area( " .. tostring(self.vO) .. ", " .. tostring(self.vSize) .. ")"
end

function Area:getPoints()
  return self.vO.x, self.vO.y, self.vO.x + self.vSize.x, self.vO.y + self.vSize.y
end

function Area:setPoints(x1,y1,x2,y2)
  self.vO.x = x1
  self.vO.y = y1
  self.vSize.x = x2-x1
  self.vSize.y = y2-y1
end

function Area:move( vDispl )
  self.vO = self.vO + vDispl
end

function Area:getRatio()
  return vSize:ratio()
end

function Area:scale( f )
  self.vSize = self.vSize * f
end

function Area:map( area, vDst )
    return v2(
      (area.vSize.x / self.vSize.x) * (vDst.x - self.vO.x) + area.vO.x,
      (area.vSize.y / self.vSize.y) * (vDst.y - self.vO.y) + area.vO.y
      )
end

function Area:getLowerRight()
  return self.vO + self.vSize
end

function Area:getLowerRightXY()
  return self.vO.x + self.vSize.x, self.vO.y + self.vSize.y
end

function Area:pointInArea( vQ ) 
    return vQ.x >= self.vO.x and
           vQ.x <= self.vO.x+self.vSize.x and
           vQ.y >= self.vO.y and
           vQ.y <= self.vO.y+self.vSize.y
end

function Area:intersects( vTest )
  return fastRectangleIntersectTest(
     self.vO.x,  self.vO.y,  self.vO.x +  self.vSize.x,  self.vO.y +  self.vSize.y,
    vTest.vO.x, vTest.vO.y, vTest.vO.x + vTest.vSize.x, vTest.vO.y + vTest.vSize.y
    )
end

function Area:fastIntersects( r1x, r1y, r2x, r2y )
  return fastRectangleIntersectTest(
     self.vO.x,  self.vO.y,  self.vO.x +  self.vSize.x,  self.vO.y +  self.vSize.y,
    r1x, r1y, r2x, r2y
    )
end

function fastRectangleIntersectTest( r1x1, r1y1, r1x2, r1y2, r2x1, r2y1, r2x2, r2y2 )
  return not ( 
		r1x2 < r2x1 or 
		r2x2 < r1x1 or
		r2y1 > r1y2 or
		r1y1 > r2y2)
end
