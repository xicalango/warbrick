-- (C) 2011 by Alexander Weld <alex.weld@gmx.net>

function love.conf(t)
	t.title = "WarBrick"
  t.author = "Alexander Weld"
  t.modules.physics = false -- don't need that
  
  t.screen.width      = 800
  t.screen.height     = 600
end
