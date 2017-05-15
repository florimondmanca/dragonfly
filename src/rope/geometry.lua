local class = require 'rope.class'


local function assertHaveXandY(...)
    for _, a in ipairs{...} do
        assert(a.x and a.y, 'both operands must have x and y fields defined')
    end
end


-- [[ Vector (2D) ]] --

local Vector = class('Vector')

function Vector:initialize(x, y)
    if type(x) == 'table' then
        y = x.y
        x = x.x
    end
    self.x = x or 0
    self.y = y or 0
end

function Vector.__add(a, b)
    assertHaveXandY(a, b)
    return Vector(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    assertHaveXandY(a, b)
    return Vector(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
    local scalar, vector

    if type(a) == 'table' then
        vector = a
        scalar = b
    else
        vector = b
        scalar = a
    end

    assertHaveXandY(vector)
    assert(type(scalar) == 'number', 'cannot multiply vector and ' .. type(scalar))
    return Vector(scalar * vector.x, scalar * vector.y)
end

function Vector:__tostring()
    return string.format('{x=%.2f, y=%.2f}', self.x, self.y)
end

function Vector:norm2(origin)
    if origin then assertHaveXandY(origin) end
    local vec = self - Vector(origin)
    return vec.x^2 + vec.y^2
end

function Vector:norm(origin)
    return math.sqrt(self:norm2(origin))
end

function Vector:rotate(angle, useRadians)
    if not useRadians then angle = (angle / 180) * math.pi end
    local c, s = math.cos(angle), math.sin(angle)
    return Vector(c * self.x - s * self.y, s * self.x + c * self.y)
end

function Vector:angle(useRadians)
    if self.x == 0 and self.y == 0 then
        return math.huge
    end
    return math.atan2(self.y, self.x) * (useRadians and 1 or 180/math.pi)
end

function Vector:dot(other)
    assertHaveXandY(other)
    return self.x * other.x + self.y * other.y
end

function Vector:project(direction)
    assertHaveXandY(direction)
    return (self:dot(direction) / direction:norm2()) * direction
end


-- [[ Transform ]] --

local Transform = class('Transform')

function Transform:initialize(position, rotation, size)
    if position and position.position then
        size = position.size
        rotation = position.rotation
        position = position.position
    end
    self.position = Vector(position)
    self.rotation = rotation or 0
    if size then
        size.x = size.x or 1
        size.y = size.y or 1
        self.size = Vector(size.x, size.y)
    else
        self.size = Vector(1, 1)
    end
end


return {
    Vector = Vector,
    Transform = Transform,
}
