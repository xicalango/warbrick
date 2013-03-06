-- warbrick (c) 2013 <weldale@gmail.com>

AssetManager = DynamicLoader:subclass("AssetManager")

function AssetManager:initialize( ... )
  DynamicLoader.initialize( self, ... )
  
  self.graphicsPreloader = nil 
  self.assets = {}
end


function AssetManager:loadCallback( newAssets )
  for i,v in ipairs(newAssets) do
    self.assets[v.id] = v
  end
end

function AssetManager:create( id )
  print(id)
  return self:_initAsset(self.assets[id])
end

function AssetManager:_initAsset( t )
  if t.type == "box" then
    return self:_initBox(t)
  elseif t.type == "graphics" then
    return self:_initGraphics(t)
  elseif t.type == "image" then
    return self:_initImage(t)
  elseif t.type == "ani" then
    return self:_initAni(t)
  else
    error("Unknown asset type")
  end
  
end

function AssetManager:_initBox(t)
  
  return BoxGraphics:new{
    size = t.size,
    mode = t.mode,
    
    offset = t.offset,
    scale = t.scale,
    shearing = t.shearing,
    tint = t.tint,
    rotationFn = t.rotationFn
    }
  
end

function AssetManager:_initImage(t)
  
  return Graphics:new{
    offset = t.offset,
    scale = t.scale,
    shearing = t.shearing,
    tint = t.tint,
    rotationFn = t.rotationFn,
    image = t.image,
    preloader = self.graphicsPreloader
    }
  
end

function AssetManager:_initAni(t)
  
  return AniGraphics:new{
    offset = t.offset,
    scale = t.scale,
    shearing = t.shearing,
    tint = t.tint,
    rotationFn = t.rotationFn,
    path = t.aniFile,
    preloader = self.graphicsPreloader
    }
  
end


