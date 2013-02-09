-- preakout (C) 2012 by Alexander Weld <alex.weld@gmx.net>

DynamicLoader = class("DynamicLoader")

function DynamicLoader:initialize( baseDir )
  self.baseDir = baseDir or ""
end


function DynamicLoader:loadFolder( folderName )

  folderName = folderName or ""

  local files = love.filesystem.enumerate( self.baseDir .. "/" .. folderName )
  
  for i,f in ipairs(files) do
    if string.match(f, "%.lua$") then
	    self:loadFile( folderName .. "/" .. f )
    end
  end
  
end

function DynamicLoader:loadFile( path )
	local chunk = love.filesystem.load( self.baseDir .. "/" .. path )
	self:loadCallback( chunk() )
end

function DynamicLoader:loadCallback( data )
	error("loadCallback not implemented.")
end
