-- Class representing camera

Camera = {}

function Camera:new()

    local object = {
        _x = 0,
        _y = 0,

        _width = 0,
        _height = 0
    }
    setmetatable(object, { __index = Camera })
    self:updateDimensions()

    return object
end

function Camera:updateDimensions()
    self._width = love.graphics.getWidth()
    self._height = love.graphics.getHeight()
end

function Camera:getWidth()
    return self._width
end

function Camera:getHeight()
    return self._height
end

function Camera:set()
    love.graphics.push()
    love.graphics.translate(-self._x, -self._y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:setX(value)
    if self._bounds then
        self._x = math.clamp(value, self._bounds.xMin, self._bounds.xMax)
    else
        self._x = value
    end
end

function Camera:setY(value)
    if self._bounds then
        self._y = math.clamp(value, self._bounds.yMin, self._bounds.yMax)
    else
        self._y = value
    end
end

function Camera:setBounds(xMin_, xMax_, yMin_, yMax_)
    self._bounds = { xMin = xMin_, xMax = xMax_,
                     yMin = yMin_, yMax = yMax_ }
end

function Camera:setPosition(x, y)
    if x then self:setX(x) end
    if y then self:setY(y) end
end

function Camera:getX()
    return self._x
end

function Camera:getY()
    return self._y
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
