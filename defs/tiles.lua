
local tiledefs = {
  
  ["#"] = {
      name = "BoundaryWall",
      type = "tile",
      walkable = false
    },
    
  [" "] = {
      name = "Floor",
      type = "tile",
	    shaded = {"#", "'"},
      walkable = true
    },
    
    ["0"] = {
      name = "Brick",
	    background = ".",
	    replaceDef = " ",
      type = "brick",
      entityId = "Brick"
    },
    
    ["B"] = {
      name = "BrickBomb",
	    background = ".",
	    replaceDef = " ",
      type = "brick",
      entityId = "BrickBomb"
    },
    
    ["1"] = {
      name = "Start Player 1",
	    background = " ",
      replaceDef = " ",
      type = "startPos",
      playerNumber = 1
    },
    ["2"] = {
      name = "Start Player 2",
  	  background = " ",
      replaceDef = " ",
      type = "startPos",
      playerNumber = 2
    },
    ["3"] = {
      name = "Start Player 3",
	    background = " ",
      replaceDef = " ",
      type = "startPos",
      playerNumber = 3
    },
    ["4"] = {
      name = "Start Player 4",
	    background = " ",
      replaceDef = " ",
      type = "startPos",
      playerNumber = 4
    }
  
}

return tiledefs
