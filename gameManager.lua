-- warbrick (C) 2013 by Alexander Weld <alex.weld@gmx.net>

GameManager = class("GameManager")

function GameManager:initialize( map, players )
  self.map = map
  self.players = players
end

function GameManager:isWall( x, y )
  return self.map:isWall( x, y ) 
end

function GameManager:isWallForEntity( e )
  return self.map:isWallForEntity( e ) 
end

function GameManager:newPlayer( number, vStart )
  vStart = vStart or v2t(self.map.startPositions[number]) or v2(0,0)
  
  local newPlayer = Player:new( vStart, number )
  
  self.players[number] = newPlayer
  
  self.map:addEntity(newPlayer)
  
  return newPlayer
end

function GameManager:newBrick( vPos )
  local newBrick = Brick:new( vPos )
  self.map:addEntity(newBrick)
  
  return newBrick
end

function GameManager:findEntities( predicateFn )
  return self.map:findEntities( predicateFn )
end

function GameManager:iFindEntities( predicateFn )
  return self.map:iFindEntities( predicateFn )
end


