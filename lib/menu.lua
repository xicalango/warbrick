-- menu.lua (c) 2013 <weldale@gmail.com>

Menu = class("Menu")

function Menu:initialize( selectCallback, width, height )
  self.items = {}
  self.font = love.graphics.newFont(12)
  
  self.selectCallback = selectCallback
  self.width = width
  self.height = height
  
  self.textColor = {255,255,255,255}
  self.backgroundColor = {0,0,0,0}
  self.highlightColor = {0,0,255,200}
  
  self.selectedItem = 0
  
  self.offset = 0
  
  self.padding = {left = 10, top = 10}
end

function Menu:addItem( id, title )
  table.insert( self.items, {id=id, title=title or id} )
end

function Menu:draw()
  local oldFont = love.graphics.getFont()
  
  local fontHeight = self.font:getHeight()
  local numItems = self.height / (fontHeight + 5)
  
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
        else
          love.graphics.setColor( self.textColor )
        end
        
        love.graphics.printf( item.title, self.padding.left,  self.padding.top + (i-1) * (fontHeight + 5), self.width )
      end
    end
    
  end)
  
  love.graphics.setFont(oldFont)
end

function Menu:keypressed( key )
  
  if util.keycheck(key, keyconfig.player[1].left) or util.keycheck(key, keyconfig.player[1].up) then
    
    
    
  elseif util.keycheck(key, keyconfig.player[1].right) or util.keycheck(key, keyconfig.player[1].down) then
  elseif util.keycheck(key, keyconfig.player[1].action) then
  end
  
  
end



