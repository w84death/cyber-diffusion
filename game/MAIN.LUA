-- -----------------------------------------
-- CYBER DIFFUSION
-- -----------------------------------------
--
-- by Krzysztof Krystian Jankowski // P1X
-- https://p1x.in
--
-- Version pre-alpha / 2022-10-09
-- Live repository at: 
-- https://github.com/w84death/cyber-diffusion
-- -----------------------------------------
-- Requiments:
-- - LoveDOS Framework
-- - DOS environment (16-bit)
-- Works on DOSBox and x86Box
-- -----------------------------------------

-- -----------------------------------------
-- VARIABLES
-- -----------------------------------------

local images = {
  splash = love.graphics.newImage('splash.gif'),
  logo = love.graphics.newImage('logo.gif'),
  city = love.graphics.newImage('city.gif'),
  cars = love.graphics.newImage('cars.gif') }
local tiles = { city={}, cars = {} }
local state = { active = 1, map = 1 }
local camera = { pos = { x = 128, y = 128 }, speed = 80 }
local debug = { preview = { show = true, tile = 1 } }
local fps = { current = 30, avr = 30, smooth = 0.9, max = 500, pos = { x = 4, y = 4 } }
local options = { debug = true, fps = true}
local intro = { blink = -1, time = 0
  logo = { x = 12, y = -100, target = { x = 12, y = 60 }, speed = 25} }

-- -----------------------------------------
-- MAPS
-- -----------------------------------------

local maps = {
  {
    width = 24,
    height = 24,
    data = {
      50, 50, 50, 19, 36, 19, 50, 50, 50, 50, 36, 36, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 18, 36, 50, 50, 50, 50, 50, 36, 36, 18, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 34, 50, 36, 50, 34, 50, 50, 17, 36, 36, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 34, 50, 36, 50, 34, 50, 9, 19, 36, 36, 9, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 33, 50, 36, 50, 33, 50, 50, 16, 36, 36, 19, 8, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 34, 50, 36, 50, 34, 50, 2, 15, 36, 36, 8, 15, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 34, 50, 36, 50, 34, 50, 50, 6, 36, 36, 7, 1, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 10, 36, 36, 33, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 9, 19, 36, 5, 50, 50, 50, 35, 36, 36, 9, 50, 2, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
      50, 50, 50, 50, 36, 29, 8, 2, 50, 10, 36, 36, 11, 16, 5, 50, 3, 2, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 30, 36, 50, 50, 2, 17, 31, 36, 36, 27, 17, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 4, 36, 36, 30, 8, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 19, 50, 50, 50, 28, 36, 36, 24, 18, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 5, 4, 11, 36, 36, 23, 7, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 19, 50, 50, 32, 36, 36, 6, 1, 8, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 18, 36, 50, 50, 50, 50, 14, 36, 36, 21, 9, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
      50, 50, 50, 50, 36, 50, 50, 10, 50, 15, 36, 36, 28, 2, 50, 3, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 19, 50, 50, 24, 36, 36, 25, 6, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 5, 36, 36, 23, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 50, 36, 36, 4, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 50, 36, 36, 18, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 36, 50, 50, 50, 50, 50, 36, 36, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
    }
  }
}

-- -----------------------------------------
-- MAIN LOOPS
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

-- -----------------------------------------
-- KEYBOARD FUNCTIONS
-- -----------------------------------------

function love.keypressed(key)
  if state.active==2 and options.debug then key_pressed(key) end
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

-- -----------------------------------------
-- SPRITES/QUADS GENERATION
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

-- -----------------------------------------
-- DRAW FUNCTIONS
-- -----------------------------------------

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
  for x = 0,maps[state.map].width-1 do
    for y = 0,maps[state.map].height-1 do
      love.graphics.draw(images.city, 
          tiles.city[ map.maps[state.map].data[map_tile] ], 
          camera.pos.x - x*64 +(y*64), 
          camera.pos.y + y*32 +(x*32))
      map_tile = map_tile+1
    end
  end 
  love.graphics.print("pre-alpha",4,200-14)  
  draw_debug()
end

function drawFPS()             
  love.graphics.setColor(255,255,255)
  love.graphics.print(
    "FPS:\n"..math.floor(fps.avr),
    pos.x,pos.y)
end

-- -----------------------------------------
-- UPDATE FUNCTIONS
-- -----------------------------------------

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

function tickFPS(dt)
  fps.current = 1/dt
  fps.avr = fps.avr * fps.smooth + fps.current * (1-fps.smooth)
  if fps.avr>fps.max then fps.avr = fps.max end
end
                                    
-- -----------------------------------------
-- END OF CODE LISTING
-- -----------------------------------------
