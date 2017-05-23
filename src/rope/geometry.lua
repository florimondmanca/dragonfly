local class = require 'rope.class'
local asserts = require 'rope.asserts'


-----------------
-- Vector (2D) --
-----------------

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


---------------
-- Transform --
---------------

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

----- initializes a circle
-- @tparam number radius > 0
-- @tparam Vector center
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


------------------------------------
-- Intersection testing functions --
------------------------------------

----- tests if two circles intersect
local function intersectingCircles(cir1, cir2, transform1, transform2)
    return (cir1:globalCenter(transform1) - cir2:globalCenter(transform2)):norm2() <= (cir1.radius + cir2.radius)^2
end

----- tests if two rectangles intersect
local function intersectingRectangles(rect1, rect2, transform1, transform2)
    rect1 = rect1:globalRectangle(transform1)
    rect2 = rect2:globalRectangle(transform2)
    return
        rect2.origin.x - rect1.width <= rect1.origin.x
        and rect1.origin.x <= rect2.origin.x + rect2.width
        and rect2.origin.y - rect1.height <= rect1.origin.y
        and rect1.origin.y <= rect2.origin.y + rect2.height
end

----- tests if a rectangle intersects with a circle
local function intersectingRectangleAndCircle(rect, cir, transform1, transform2)
    rect = rect:globalRectangle(transform1)
    cir = cir:globalCircle(transform2)

    for _, vertex in ipairs(rect:vertices()) do
        if cir:contains(vertex) then return true end
    end

    return rect:contains(cir.center)
end

--- tests if two shapes interesect.
-- supports points, axis-aligned rectangles and circles.
-- @tparam Shape shape1
-- @tparam Shape shape2
-- @tparam Transform transform1
-- @tparam Transform transform2
local function intersecting(shape1, shape2, transform1, transform2)
    assert(
        class.isInstanceOf(shape1, Shape, Vector)
        and class.isInstanceOf(shape2, Shape, Vector),
        'both shapes must be instances of Shape or Vector'
    )
    transform1 = Transform(transform1)
    transform2 = Transform(transform2)
    local shape1Type = class.isInstanceOf(shape1, Vector, Rectangle, Circle)
    local shape2Type = class.isInstanceOf(shape2, Vector, Rectangle, Circle)

    -- intersection between a point and...
    if shape1Type == Vector then
        -- ... a point
        if shape2Type == Vector then
            shape1 = shape1 + transform1.position
            shape2 = shape2 + transform2.position
            return shape1.x == shape2.x and shape1.y == shape2.y
        -- ... a circle
        elseif shape2Type == Circle then
            return shape2:contains(shape1)
        -- ... a rectangle
        elseif shape2Type == Rectangle then
            return shape2:contains(shape1)
        end

    -- intersection between a rectangle and...
    elseif shape1Type == Rectangle then
        -- ... a point
        if shape2Type == Vector then
            return shape1:contains(shape2)
        --- ... a circle
        elseif shape2Type == Circle then
            return intersectingRectangleAndCircle(shape1, shape2, transform1, transform2)
        elseif shape2Type == Rectangle then
            return intersectingRectangles(shape1, shape2, transform1, transform2)
        end

    -- intersection between a circle and ...
    elseif shape1Type == Circle then
        -- ... a point
        if shape2Type == Vector then
            return shape1:contains(shape2)
        -- ... a circle
        elseif shape2Type == Circle then
            return intersectingCircles(shape1, shape2, transform1, transform2)
        -- ... a rectangle
        elseif shape2Type == Rectangle then
            return intersectingRectangleAndCircle(shape2, shape1, transform2, transform1)
        end
    end
end


return {
    Vector = Vector,
    Transform = Transform,
    Circle = Circle,
    Rectangle = Rectangle,
    intersecting = intersecting,
}
