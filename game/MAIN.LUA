-- CYBER DIFFUSION
-- by Krzysztof Krystian Jankowski // P1X

require("fps")
require("city")

local sx=0
local sy=0
local splash_img = love.graphics.newImage('splash.gif')
local logo_img = love.graphics.newImage('logo.gif')
local city_sheet = love.graphics.newImage('city.gif')
local city_tiles = {}
local speed=80
local preview_tile = 1
local state = 1

function love.load()
  for y = 0, 5 do
  for x = 0, 9 do
    table.insert(city_tiles,love.graphics.newQuad(x*128,y*256,128,256))
  end
  end
end
local logo_x = 12
local logo_y = -100
local blink = -1

function love.draw()    
  i=1
  if state==1 then
        love.graphics.draw(splash_img,0,0)
        love.graphics.draw(logo_img,logo_x,logo_y)
        love.graphics.setColor(0,0,0)
        if logo_y > 55 then 
          love.graphics.print("P1X PRESENTS",130,45)
          if blink>0 then love.graphics.setColor(255,255,255) end
          love.graphics.print("PRESS SPACEBAR",120,180) 
        end
  end

  if state==2 then
  for x = 0,map.layers[1].width-1 do
  for y = 0,map.layers[1].height-1 do
    love.graphics.draw(city_sheet, 
        city_tiles[ map.layers[1].data[i] ], 
        sx - x*64 +(y*64), 
        sy + y*32 +(x*32)
    )
    i=i+1
  end
  
  end
  love.graphics.print("CYBER DIFFUSION by P1X",4,200-14)  

  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("line", 320-130, 1, 128, 200-4)
  love.graphics.draw(city_sheet, city_tiles[preview_tile], 320-130, -60)
  love.graphics.print(preview_tile, 320-128,2)
  drawFPS()
  end 
end
local t = 0

function love.update(dt)
  tickFPS(dt)   
  t=t+1
  if state==1 then
    if love.keyboard.isDown("space") then
      state=2
    end
    if logo_y < 60 then 
        logo_y = logo_y + dt*25 
    end
    if t%33==0 then blink = blink * -1 end   
  end

  if love.keyboard.isDown("escape") then love.event.quit() end 

  if state==2 then
    if love.keyboard.isDown("w") then sy = sy + dt*speed end 
    if love.keyboard.isDown("s") then sy = sy - dt*speed end
    if love.keyboard.isDown("a") then sx = sx + dt*speed end
    if love.keyboard.isDown("d") then sx = sx - dt*speed end
  end
end

function love.keypressed(key)
  if state==2 then

  if key == "e" then 
    if preview_tile < 50 then
      preview_tile = preview_tile + 1
    end     
  end
  if key == "q" then 
    if preview_tile > 1 then
      preview_tile = preview_tile - 1
    end     
  end 

  end
end
