-- preakout (C) 2012 by Alexander Weld <alex.weld@gmx.net>

DynamicLoader = class("DynamicLoader")

function DynamicLoader:loadFolder( folderName )

  local files = love.filesystem.enumerate( folderName )
  
  for i,f in ipairs(files) do
    if string.match(f, "%.lua$") then
	    self:loadFile( folderName .. "/" .. f )
    end
  end
  
end

function DynamicLoader:loadFile( path )
	local chunk = love.filesystem.load( path )
	self:loadCallback( chunk() )
end

function DynamicLoader:loadCallback( data )
	error("loadCallback not implemented.")
end
