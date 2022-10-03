local current = 30
local fps = 30
local smooth = 0.9
local max = 500
local pos = { x = 4, y = 4 }

function tickFPS(dt)
  current = 1/dt
  fps = fps * smooth + current * (1-smooth)
  if fps>max then fps = max end
end
                                      
function drawFPS()             
  love.graphics.setColor(255,255,255)
  love.graphics.print(
    "FPS:\n"..math.floor(fps),
    pos.x,pos.y)
end
