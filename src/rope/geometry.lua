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
    asserts.isInstanceOfOrNil(Vector, center, 'center')
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


----------
-- Edge --
----------

local Edge = Shape:subclass('Edge')

----- initializes an Edge
-- an Edge Shape is a line segment. they can be used to create the boundaries
-- of the terrain.
-- @tparam Vector a one vertex of the edge
-- @tparam Vector b the other vertex of the edge
function Edge:initialize(point1, point2)
    asserts.isInstanceOfOrNil(Vector, point1, 'point1')
    asserts.isInstanceOfOrNil(Vector, point2, 'point2')
    assert(point1.x ~= point2.x or point1.y ~= point2.y,
    'Edge must have distinct vertices, where:' .. tostring(point1) .. ' and ' .. tostring(point2))
    self.point1 = point1
    self.point2 = point2
end

function Edge:coords()
    return self.point1.x, self.point1.y, self.point2.x, self.point2.y
end

function Edge:vertices()
    return {self.point1, self.point2}
end

function Edge:globalVertices(transform, ignoreRotation)
	local globalVertices = {}
	for i, vertex in ipairs(self:vertices()) do
		globalVertices[i] = Vector(vertex.x * transform.size.x, vertex.y * transform.size.y)
		if not ignoreRotation then
			globalVertices[i] = globalVertices[i]:rotate(transform.rotation) + transform.position
		end
	end
	return globalVertices
end

function Edge:globalEdge(transform)
    return Edge(unpack(self:globalVertices(transform)))
end

function Edge:contains(vector)
    local u = self.point2 - self.point1
    local v = vector - self.point1
    return
        u.y*v.x == v.y*u.x -- colinear
        and (0 <= v.x/u.x and v.x/u.x <= 1 and 0 <= v.y/u.y and v.y/u.y <= 1) -- lies on segment
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
    asserts.hasType('number', width, 'width')
    asserts.hasType('number', height, 'height')
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

function Rectangle:edges()
    local vertices = self:vertices()
    return {
        top = Edge(vertices.topleft, vertices.topright),
        right = Edge(vertices.topright, vertices.bottomright),
        bottom = Edge(vertices.bottomright, vertices.bottomleft),
        left = Edge(vertices.bottomleft, vertices.topleft)
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

------------------
-- Line Polygon --
------------------


local Polygon = Shape:subclass('Polygon')

function Polygon:initialize(vertices)
	local originalVType = type(vertices[1])
	local newVerts = {}

	for i, v in ipairs(vertices) do
		--ensure type consistency
		if i ~= 1 then
			assert(type(v) == originalVType, "vertices must be all nums or all tables")
		end

		if originalVType == "number" and i % 2 == 1 then
			newVerts[math.floor(i/2) + 1] = Vector(v, vertices[i+1])
		elseif originalVType == "table" then
			newVerts[i] = Vector(v)
		end
	end
	self.vertices = newVerts
end

function Polygon:globalVertices(transform)
    local globalVertices = {}
    for i, vertex in ipairs(self.vertices) do
        globalVertices[i] = Vector(vertex.x * transform.size.x, vertex.y * transform.size.y)
        if transform.rotation ~= 0 then
            globalVertices[i] = globalVertices[i]:rotate(transform.rotation) + transform.position
        end
	end

	return globalVertices
end

function Polygon:edges()
    local edges = {}
    for i = 1, #self.vertices - 1 do
        table.insert(edges, Edge(self.vertices[i], self.vertices[i+1]))
    end
    table.insert(edges, Edge(self.vertices[#self.vertices], self.vertices[1]))
    return edges
end

function Polygon:coords()
    local coords = {}
    for _, vertex in ipairs(self.vertices) do
        table.insert(coords, vertex.x)
        table.insert(coords, vertex.y)
    end
    return coords
end

function Polygon:globalCoords(transform)
    return (self:globalPolygon(transform)):coords()
end

function Polygon:globalPolygon(transform)
	return self.class(self:globalVertices(transform))
end


------------------------------------
-- Intersection testing functions --
------------------------------------

----- tests if two circles intersect
local function intersectingCircles(cir1, cir2, transform1, transform2)
    return (cir1:globalCenter(transform1) - cir2:globalCenter(transform2)):norm2() <= (cir1.radius + cir2.radius)^2
end

----- tests if a circle and an edge intersect
local function intersectingCircleAndEdge(cir, edge, transform1, transform2)
    local c = cir:globalCircle(transform1).center
    local a, b = unpack(edge:globalVertices(transform2))
    local ab = b - a  -- direction a -> b
    -- d is the projection of c on the segment ab
    local d = a + ((c-a):dot(ab))/ab:norm2() * ab
    -- intersection if d is inside the circle
    return d:norm2() <= cir.radius^2
end

----- tests if two edges intersect
local function intersectingEdges(edge1, edge2, transform1, transform2)
    local points1 = edge1:globalVertices(transform1)
    local points2 = edge2:globalVertices(transform2)
    local u1, u2 = points1[1], points2[1]
    local v1, v2 = points1[2] - points1[1], points2[2] - points2[1]
    local b = u2 - u1
    local det = -(v1.x * v2.y - v1.y * v2.x)
    -- if det == 0, edges are colinear and do not intersect
    if det == 0 then return false end
    --
    local t1 = (-v2.y * b.x + v2.x * b.y)/det
    local t2 = (-v1.y * b.x + v1.x * b.y)/det
    return 0 <= t1 and t1 <= 1 and 0 <= t2 and t2 <= 1
end

----- tests if two (axis-aligned) rectangles intersect
local function intersectingRectangles(rect1, rect2, transform1, transform2)
    rect1 = rect1:globalRectangle(transform1)
    rect2 = rect2:globalRectangle(transform2)
    return
        rect2.origin.x - rect1.width <= rect1.origin.x
        and rect1.origin.x <= rect2.origin.x + rect2.width
        and rect2.origin.y - rect1.height <= rect1.origin.y
        and rect1.origin.y <= rect2.origin.y + rect2.height
end

----- tests if a rectangle intersects with an edge
local function intersectingRectangleAndEdge(rect, edge, transform1, transform2)
    -- intersection <=> the edge collides with one of the rectangle's sides
    for _, side in pairs(rect:edges()) do
        if intersectingEdges(side, edge, transform1, transform2) then
            return true
        end
    end
    return false
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

local function any(condition, list)
    for _, element in ipairs(list) do
        if condition(element) then return true end
    end
    return false
end

local function intersectingPolygonAndVector(poly, vector, transform1, transform2)
    poly = poly:globalPolygon(transform1)
    vector = vector + transform2.position
    return any(function(edge) return edge:contains(vector) end, poly:edges())
end


local function intersectingPolygonAndOther(poly, other, transform1, transform2)
    local otherType = class.isInstanceOf(other, Vector, Rectangle, Circle, Edge)
    if otherType == Vector then
        return intersectingPolygonAndVector(poly, other, transform1, transform2)

    elseif otherType == Edge then
        return any(function(edge)
            return intersectingEdges(edge, other, transform1, transform2)
        end, poly:edges())

    elseif otherType == Rectangle then
        return any(function(edge)
            return intersectingRectangleAndEdge(other, edge, transform2, transform1)
        end, poly:edges())

    elseif otherType == Circle then
        other = other:globalCircle(transform2)
        return any(function(edge)
            return intersectingCircleAndEdge(other, edge, transform1, transform2)
        end, poly:edges())
    end
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
    local shape1Type = class.isInstanceOf(shape1, Vector, Rectangle, Circle, Edge, Polygon)
    local shape2Type = class.isInstanceOf(shape2, Vector, Rectangle, Circle, Edge, Polygon)

    if shape1Type == Polygon then
        return intersectingPolygonAndOther(shape1, shape2, transform1, transform2)
    elseif shape2Type == Polygon then
        return intersectingPolygonAndOther(shape2, shape1, transform2, transform1)
    end

    -- intersection between a point and...
    if shape1Type == Vector then
        -- ... a point
        if shape2Type == Vector then
            shape1 = shape1 + transform1.position
            shape2 = shape2 + transform2.position
            return shape1.x == shape2.x and shape1.y == shape2.y
        -- ... a circle, a rectangle or an edge
        else
            return shape2:contains(shape1)
        end

    -- intersection between an edge and...
    elseif shape1Type == Edge then
        -- ... a point
        if shape2Type == Vector then
            return shape1:contains(shape2)
        -- ... an edge
        elseif shape2Type == Edge then
            return intersectingEdges(shape1, shape2, transform1, transform2)
        -- ... a rectangle
        elseif shape2Type == Rectangle then
            return intersectingRectangleAndEdge(shape2, shape1, transform2, transform1)
        -- ... a circle
        elseif shape2Type == Circle then
            return intersectingCircleAndEdge(shape2, shape1, transform2, transform1)
        end

    -- intersection between a rectangle and...
    elseif shape1Type == Rectangle then
        -- ... a point
        if shape2Type == Vector then
            return shape1:contains(shape2)
        -- an edge
        elseif shape2Type == Edge then
            return intersectingRectangleAndEdge(shape1, shape2, transform1, transform2)
        -- ... a circle
        elseif shape2Type == Circle then
            return intersectingRectangleAndCircle(shape1, shape2, transform1, transform2)
        -- ... a rectangle
        elseif shape2Type == Rectangle then
            return intersectingRectangles(shape1, shape2, transform1, transform2)
        end

    -- intersection between a circle and ...
    elseif shape1Type == Circle then
        -- ... a point
        if shape2Type == Vector then
            return shape1:contains(shape2)
        -- ... an edge
        elseif shape2Type == Edge then
            return intersectingCircleAndEdge(shape1, shape2, transform1, transform2)
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
    Edge = Edge,
    Circle = Circle,
    Rectangle = Rectangle,
    Polygon = Polygon,
    intersecting = intersecting,
}
