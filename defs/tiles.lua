
local tiledefs = {
  
  ["#"] = {
      name = "BoundaryWall",
      type = "tile",
      walkable = false,
      wall = true
    },
    
    [" "] = {
      name = "Floor",
      type = "tile",
      walkable = true,
      wall = false
    },
    
    ["0"] = {
      name = "Brick",
      type = "brick",
      entityId = "brick"
    },
    
    ["1"] = {
      name = "Start Player 1",
      type = "startPos",
      playerNumber = 1
    },
    ["2"] = {
      name = "Start Player 2",
      type = "startPos",
      playerNumber = 2
    },
    ["3"] = {
      name = "Start Player 3",
      type = "startPos",
      playerNumber = 3
    },
    ["4"] = {
      name = "Start Player 4",
      type = "startPos",
      playerNumber = 4
    }
  
}

return tiledefs
