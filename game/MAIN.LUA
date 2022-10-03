-- CYBER DIFFUSION
-- by Krzysztof Krystian Jankowski // P1X
--
-- Version pre-alpha
-- -----------------------------------------

require("fps")
require("city")

-- -----------------------------------------

local images = {
  splash = love.graphics.newImage('splash.gif'),
  logo = love.graphics.newImage('logo.gif'),
  city = love.graphics.newImage('city.gif'),
  cars = love.graphics.newImage('cars.gif')
}
local tiles = { city={}, cars = {} }

local state = { active = 1}
local camera = { pos = { x = 128, y = 128 }, speed = 80 }

local debug = {
  preview = { show = true, tile = 1 }
}

local options = {
  debug = true,
  fps = true
}

local intro = {
  logo = { x = 12, y = -100, target = { x = 12, y = 60 }, speed = 25},
  blink = -1,
  time = 0
}


-- -----------------------------------------

function love.load()
  make_sprites()
end

function love.draw()    
  if state.active==1 then draw_state_1() end
  if state.active==2 then draw_state_2() end 
end

function love.update(dt)
  if options.fps then tickFPS(dt) end   
  if love.keyboard.isDown("escape") then love.event.quit() end 
  if state.active == 1 then update_state_1(dt) end
  if state.active == 2 then update_state_2(dt) end
end

function love.keypressed(key)
  if state.active==2 and options.debug then key_pressed(key) end
end

-- -----------------------------------------

function make_sprites()
  for y = 0, 5 do
    for x = 0, 9 do
      table.insert(tiles.city,love.graphics.newQuad(x*128,y*256,128,256))
    end
  end  
  for y = 0, 7 do
    for x = 0, 3 do
      table.insert(tiles.cars,love.graphics.newQuad(x*128,y*64,128,64))
    end
  end
end

function draw_state_1()
  love.graphics.draw(images.splash,0,0)
  love.graphics.draw(images.logo,intro.logo.x,intro.logo.y)
  love.graphics.setColor(0,0,0)
  if intro.logo.y > intro.logo.target.y then 
    love.graphics.print("P1X PRESENTS",130,45)
    if intro.blink>0 then love.graphics.setColor(255,255,255) end
    love.graphics.print("PRESS SPACEBAR",120,180) 
  end
end

function draw_state_2()
  local map_tile = 1
  for x = 0,map.layers[1].width-1 do
    for y = 0,map.layers[1].height-1 do
      love.graphics.draw(images.city, 
          tiles.city[ map.layers[1].data[map_tile] ], 
          camera.pos.x - x*64 +(y*64), 
          camera.pos.y + y*32 +(x*32))
      map_tile = map_tile+1
    end
  end 
  love.graphics.print("pre-alpha",4,200-14)  
  draw_debug()
end

function draw_debug()
  if options.fps then drawFPS() end
  if options.debug then
    if debug.preview.show then
      love.graphics.setColor(255,255,255)
      love.graphics.rectangle("line", 320-130, 1, 128, 200-4)
      love.graphics.draw(images.city, tiles.city[debug.preview.tile], 320-130, -60)
      love.graphics.print(debug.preview.tile, 320-128,2)
    end
  end  
end

function update_state_1(dt)
  intro.time = intro.time+1
  if love.keyboard.isDown("space") then state.active = 2 end
  if intro.logo.y < intro.logo.target.y then 
      intro.logo.y = intro.logo.y + dt*intro.logo.speed
  end
  if intro.time%33 == 0 then intro.blink = intro.blink * -1 end   
end

function update_state_2(dt)
  if love.keyboard.isDown("w") then camera.pos.y = camera.pos.y + dt*camera.speed end 
  if love.keyboard.isDown("s") then camera.pos.y = camera.pos.y - dt*camera.speed end
  if love.keyboard.isDown("a") then camera.pos.x = camera.pos.x + dt*camera.speed end
  if love.keyboard.isDown("d") then camera.pos.x = camera.pos.x - dt*camera.speed end
end

function key_pressed(key)
  if key == "e" then 
    if debug.preview_tile < 50 then
      debug.preview_tile = debug.preview_tile + 1
    end     
  end
  if key == "q" then 
    if debug.preview_tile > 1 then
      debug.preview_tile = debug.preview_tile - 1
    end     
  end 
end