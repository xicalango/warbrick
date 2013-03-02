-- menu.lua (c) 2013 <weldale@gmail.com>

Menu = class("Menu")

function Menu:initialize( width, height, selectCallback, onChangeCallback )
  self.items = {}
  self.font = love.graphics.newFont(12)
  
  self.selectCallback = selectCallback
  self.onChangeCallback = onChangeCallback
  self.width = width
  self.height = height
  
  self.textColor = {255,255,255,255}
  self.backgroundColor = {0,0,0,0}
  self.highlightColor = {0,255,255,255}
  
  self.selectedItem = 0
  
  self.offset = 0
  
  self.padding = {left = 10, top = 10, font = 5}
end

function Menu:addItem( id, title )
  table.insert( self.items, {id=id, title=title or id} )
end

function Menu:sort()
  table.sort( self.items, function( i1, i2 )
      return i1.id < i2.id
    end)
end

function Menu:selectFirstItem()
  if #self.items > 0 then
    self.selectedItem = 1
  end
end

function Menu:update(dt)
  
end

function Menu:numItemsPerPage()
  return math.floor(self.height / (self.font:getHeight() + self.padding.font))
end


function Menu:draw()
  local oldFont = love.graphics.getFont()
  
  local fontHeight = self.font:getHeight()
  local numItems = self:numItemsPerPage()
  
  love.graphics.setFont(self.font)
  
  util.preserveColor(function()
 
    love.graphics.setColor( self.backgroundColor )
    
    love.graphics.rectangle( "fill", 0, 0, self.width, self.height )
  
    for i = 1, numItems do
      local itemIdx = self.offset + i
      if itemIdx <= #self.items then
        local item = self.items[itemIdx]
      
        if itemIdx == self.selectedItem then
          love.graphics.setColor( self.highlightColor )
          
          love.graphics.rectangle( "line", self.padding.left / 2, self.padding.top + (i-1) * (fontHeight + self.padding.font), self.width - self.padding.left, fontHeight )
          
        else
          love.graphics.setColor( self.textColor )
        end
        
        love.graphics.printf( item.title, self.padding.left,  self.padding.top + (i-1) * (fontHeight + self.padding.font), self.width )
      end
    end
    
  end)
  
  love.graphics.setFont(oldFont)
end

function Menu:keypressed( key )
  if util.keycheck(key, keyconfig.player[1].left) or util.keycheck(key, keyconfig.player[1].up) then
    self.selectedItem = self.selectedItem - 1
    self:_normalizeSelectedItem()
  elseif util.keycheck(key, keyconfig.player[1].right) or util.keycheck(key, keyconfig.player[1].down) then
    self.selectedItem = self.selectedItem + 1
    self:_normalizeSelectedItem()
  elseif util.keycheck(key, keyconfig.player[1].action) then
    
    if self.selectedItem ~= 0 then
      self.selectCallback( self.selectedItem, self.items[self.selectedItem] )
    end
    
  elseif util.keycheck(key, keyconfig.player[1].action2) then
    self.selectCallback( nil, nil )
  end
end

function Menu:_normalizeSelectedItem()
  
  if #self.items == 0 then
    return
  end
  
  if self.selectedItem <= 0 then
    self.selectedItem = #self.items
  end
  
  if self.selectedItem > #self.items then
    self.selectedItem = 1
  end
  
  local numItems = self:numItemsPerPage()
  
  if self.selectedItem < self.offset + 1 then
    self.offset = self.selectedItem - 1
  elseif self.selectedItem > self.offset + numItems then
    self.offset = self.selectedItem -  numItems
  end
  
  
  if self.onChangeCallback then
    self.onChangeCallback( self.selectedItem, self.items[self.selectedItem] )
  end
  
end

