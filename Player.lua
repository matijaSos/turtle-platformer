-- Class representing a main hero in our platformer

Player = {}

-- Constructor
function Player:new()
    -- Create new object
    local object = {
        --[[
        x = 64,
        y = 64,
        width = 0,
        height = 0,
        --]]
        type = 'player',

        xSpeed = 0,
        ySpeed = 0,
        jumpSpeed = -800,
        runSpeed = 200,

        state = "",
        inAir = true,
        orientation = "right",

        collidingRect = collider:addRectangle(64, 64, 48, 32),

        imgs = {
            left = love.graphics.newImage("img/turtle-left.png"),
            right = love.graphics.newImage("img/turtle.png")
        }
    }
    setmetatable(object, { __index = Player })
    return object
end

function Player:getImg()
    return self.imgs[self.orientation]
end

-- Movement functions
function Player:jump()
    if not self.inAir then
        self.ySpeed = self.jumpSpeed
        self.inAir = true
    end
end

function Player:moveRight()
    self.xSpeed = self.runSpeed
    self.state = "moveRight"
    self.orientation = "right"
end

function Player:moveLeft()
    self.xSpeed = -1 * (self.runSpeed)
    self.state = "moveLeft"
    self.orientation = "left"
end

function Player:stop()
    self.xSpeed = 0
    self.state = "stand"
end

function Player:collideWithTile(shape_a, shape_b, mtv_x, mtv_y)

    local rect, tile
    if shape_a == self.collidingRect and shape_b.type == 'tile' then
        rect = shape_a
    elseif shape_b == self.collidingRect and shape_a.type == 'tile' then
        rect = shape_b
    else
        return
    end

    -- Detect collision type
    if mtv_y < 0 then       -- Floor is hit
        self.ySpeed = 0 
        self.inAir = false
    elseif mtv_y > 0 then   -- Ceiling is hit
        self.ySpeed = 0
    end

    -- Move to resolve collision
    --[[
    if mtv_x > 0 then mtv_x = mtv_x + 1 end
    if mtv_x < 0 then mtv_x = mtv_x - 1 end

    if mtv_y > 0 then mtv_y = mtv_y + 1 end
    if mtv_y < 0 then mtv_y = mtv_y - 1 end
    --]]

    rect:move(mtv_x, mtv_y)
    
end

function Player:collideWithTileOver(shape_a, shape_b)

    local rect, tile
    if shape_a == self.collidingRect and shape_b.type == 'tile' or
       shape_b == self.collidingRect and shape_a.type == 'tile' 
    then
        self.inAir = true
    else
        return
    end

end

function Player:getCenter()
    return self.collidingRect:center()
end

function Player:draw()
    -- self.collidingRect:draw('fill')

    local x, y, _, _ = self.collidingRect:bbox()

    love.graphics.draw(self:getImg(), x, y)
end

function Player:update(dt, gravity)

    -- Apply gravity if player is in air
    if self.inAir then
        self.ySpeed = self.ySpeed + (gravity * dt)
    end
    
    -- Update the player's state
    
    --[[
    if not(self.canJump) then
        if self.ySpeed < 0 then
            self.state = "jump"
        elseif self.ySpeed > 0 then
            self.state = "fall"
        end
    else
        if self.xSpeed > 0 then
            self.state = "moveRight"
        elseif self.xSpeed < 0 then
            self.state = "moveLeft"
        else
            self.state = "stand"
        end
    end
    --]]

    self.collidingRect:move(self.xSpeed*dt, self.ySpeed*dt)
end
