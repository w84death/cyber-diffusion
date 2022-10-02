-- CYBER DIFFUSION
-- by Krzysztof Krystian Jankowski // P1X

require("fps")
require("city")

local sx=0
local sy=0
local city_sheet = love.graphics.newImage('city.gif')
local city_tiles = {}
local speed=80
local preview_tile = 1

function love.load()
  for y = 0, 5 do
  for x = 0, 10 do
    table.insert(city_tiles,love.graphics.newQuad(x*128,y*256,128,256))
  end
  end
end

function love.draw()    
  i=1
  for x = 0,map.layers[1].width-1 do
  for y = 0,map.layers[1].height-1 do
    love.graphics.draw(city_sheet, 
        city_tiles[ map.layers[1].data[i] +1 ], 
        sx - x*64 +(y*64), 
        sy + y*32 +(x*32)
    )
    i=i+1
  end
  
  end
  love.graphics.print("16-BIT NIGHT CITY by P1X",90,8)  

  --love.graphics.setColor(128,128,128)
  --love.graphics.rectangle("fill", 4, 4, 128, 256)
  --love.graphics.draw(city_sheet, city_tiles[preview_tile], 4, 4)

  drawFPS()
end

function love.update(dt)
  tickFPS(dt)   

  if love.keyboard.isDown("w") then sy = sy + dt*speed end 
  if love.keyboard.isDown("s") then sy = sy - dt*speed end
  if love.keyboard.isDown("a") then sx = sx + dt*speed end
  if love.keyboard.isDown("d") then sx = sx - dt*speed end

  if love.keyboard.isDown("e") then 
        if preview_tile < 50 then
                preview_tile = preview_tile + 1
        end     
  end 
  if love.keyboard.isDown("q") then 
        if preview_tile > 1 then
          preview_tile = preview_tile - 1
        end     
  end 

end
