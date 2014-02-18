
local loader    = require "lib.Advanced-Tiled-Loader.Loader"
local HC        = require "lib.HardonCollider"

require "Player"
require "Camera"

------------- Handling input --------------

function handleInput(dt)

    if love.keyboard.isDown('left') then
        turtle:moveLeft()        
    end
    if love.keyboard.isDown('right') then
        turtle:moveRight()
    end
    
    if love.keyboard.isDown('up') then
        turtle:jump()
    end
    --[[
    if love.keyboard.isDown('down') then
        hero:move(0, hero.speed * dt)
    end
    --]]

end

------------------ Collision stuff -----------------------

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)

    turtle:collideWithTile(shape_a, shape_b, mtv_x, mtv_y)
    
end

function collide_stop(dt, shape_a, shape_b)

    turtle:collideWithTileOver(shape_a, shape_b)

end

function findSolidTiles(map)

    local solidTiles = {}

    for x, y, tile in map("Tiles"):iterate() do

        local ctile = collider:addRectangle(x*tileWidth, y*tileHeight,
                                            tileWidth, tileHeight)
        ctile.type = "tile"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
        table.insert(solidTiles, ctile)
    end

    return solidTiles
end

function love.load()

    loader.path = "maps/"
    map = loader.load("map01.tmx")

    collider = HC(100, on_collide, collide_stop)

    camera = Camera:new()

    -- Initialize other stuff
    tileWidth  = map.tileWidth
    tileHeight = map.tileHeight

    solidTiles = findSolidTiles(map)

    -- Initialize player
    turtle = Player:new()

    gravity = 1800

end

function love.update(dt)

    handleInput(dt)
    turtle:update(dt, gravity)
    collider:update(dt)

end

function love.draw()

    ----------------------- Camera ---------------------------

    local x, y = turtle:getCenter()
    x = math.floor(x)
    y = math.floor(y)
    -- We update it constantly, because window can get resized
    camera:updateDimensions()
    local w, h = camera:getWidth(), camera:getHeight()

    camera:setBounds(0, map.width*tileWidth - w,
                     0, map.height*tileHeight - h)

    -- We want turtle to be in the center of screen
    camera:setPosition(x - w/2, y - h/2)
    camera:set()

    map:setDrawRange(camera:getX(), camera:getY(), w, h)

    -- Draw the map
    map:draw()
    --Draw player
    turtle:draw()

    ---------------------------- Debugging stuff --------------------------------

    -- Draw solid tiles
    --[[
    for idx, tile in pairs(solidTiles) do
        tile:draw()
    end
    ]]

    -- Print debug information
    local camX, camY = camera:getX(), camera:getY()

    love.graphics.print("Player coordinates: ("..x..","..y..")", 5+camX, 5+camY)
    love.graphics.print("Current state: "..turtle.state, 5+camX, 20+camY)
    love.graphics.print("Orientation: "..turtle.orientation, 5+camX, 35+camY)
    love.graphics.print("In air: "..tostring(turtle.inAir), 5+camX, 50+camY)
    love.graphics.print("Upper left corner: "..camX.." "..camY, 5+camX, 65+camY)

    camera:unset()
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
    if (key == "right") or (key == "left") then
        turtle:stop()
    end
end
