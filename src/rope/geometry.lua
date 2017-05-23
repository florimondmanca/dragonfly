local class = require 'rope.class'
local asserts = require 'rope.asserts'


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
    asserts.haveXandY(a, b)
    return Vector(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    asserts.haveXandY(a, b)
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

    asserts.haveXandY(vector)
    assert(type(scalar) == 'number', 'cannot multiply vector and ' .. type(scalar))
    return Vector(scalar * vector.x, scalar * vector.y)
end

function Vector:__tostring()
    return string.format('{x=%.2f, y=%.2f}', self.x, self.y)
end

function Vector:norm2(origin)
    if origin then asserts.haveXandY(origin) end
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
    asserts.haveXandY(other)
    return self.x * other.x + self.y * other.y
end

function Vector:project(direction)
    asserts.haveXandY(direction)
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


------------
-- Shapes --
------------

local Shape = class('Shape')


------------
-- Circle --
------------

local Circle = Shape:subclass('Circle')

function Circle:initialize(radius, center)
    asserts.hasType('number', radius, 'radius')
    asserts.isInstanceOfOrNil(Shape, center, 'center')
    self.radius = radius
    self.center = center or Vector()
end

function Circle:area()
    return math.pi * self.radius^2
end

function Circle:circumference()
    return 2*math.pi * self.radius
end

function Circle:globalCenter(transform)
    return transform.position + self.center
end

function Circle:globalCircle(transform)
    return Circle(self.radius * transform.size.x,
        self:globalCenter(transform)
    )
end

function Circle:contains(vector)
    return (vector - self.center):norm2() <= self.radius^2
end


---------------
-- Rectangle --
---------------

local Rectangle = Shape:subclass('Rectangle')

----- initializes a Rectangle
-- origin is assumed to be the topleft corner
-- @tparam number width > 0
-- @tparam number height > 0
function Rectangle:initialize(width, height, origin)
    asserts.isType('number', width, 'width')
    asserts.isType('number', height, 'height')
    asserts.isInstanceOfOrNil(Vector, origin, 'origin')
    self.width = width
    self.height = height
    self.origin = origin or Vector()
end

function Rectangle:vertices()
    return {
        topleft = self.origin,
        topright = self.origin + Vector(self.width, 0),
        bottomleft = self.origin + Vector(0, self.height),
        bottomright = self.origin + Vector(self.width, self.height),
    }
end

function Rectangle:globalVertices(transform, ignoreRotation)
	local globalVertices = {}
	for position, vertex in pairs(self:vertices()) do
		globalVertices[position] = Vector(vertex.x * transform.size.x, vertex.y * transform.size.y)
		if not ignoreRotation then
			globalVertices[position] = globalVertices[position]:rotate(transform.rotation) + transform.position
		end
	end
	return globalVertices
end

function Rectangle:globalRectangle(transform)
	return Rectangle(
		self.width * transform.size.x,
		self.height * transform.size.y,
		self.origin + transform.position
	)
end

function Rectangle:contains(vector)
	return
		vector.x >= self.origin.x and
		vector.x <= self.origin.x + self.width and
		vector.y >= self.origin.y and
		vector.y <= self.origin.y + self.height
end


return {
    Vector = Vector,
    Transform = Transform,
    Circle = Circle,
    Rectangle = Rectangle,
}
