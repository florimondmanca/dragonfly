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
        and (0 <= v.x/u.x <= 1 and 0 <= v.y/u.y <= 1) -- lies on segment
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

function Rectangle:sides()
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


-------------
-- Polygon --
-------------

----- tests collision between a polygon and something else
local function intersectingPolygonAndOther(poly1, other, transform1, transform2)
	transform1 = transform1 or Transform()

	local poly1Verts = poly1:globalVertices(transform1)
	local otherVerts
	local otherType = class.isInstanceOf(other, Vector, Circle)
	if otherType == Vector then
		otherVerts = {other}
	elseif otherType == Circle then
		local gc = other:globalCircle(transform2)
		--we will rotate the "vertices" (center and two outmost points) on each new axis
		otherVerts = {
			gc.center - Vector(gc.radius, 0),
			gc.center,
			gc.center + Vector(gc.radius, 0)
		}
	else
		otherVerts = other:globalVertices(transform2)
	end

	--check against every axis of both colliders
	--if collider is polygon, axis is normal of a side
	--if collider is circle, axis is the line between the closest polygon vertex and the circle center
	for icollider, collider in ipairs({poly1Verts, otherVerts}) do
		local len = #collider

		--if the 2nd collider has only one vertex, we've already checked it
		if len < 2 and icollider == 2 then
			return true
		end

		local normal = nil
		local minSm = nil
		local closest = nil

		--if this collider is a circle, we generate the "normal" here
		if icollider == 2 and otherType == Circle then
			for _, vertex in ipairs(poly1Verts) do
				local sm = (vertex - other:globalCenter(transform2)):sqrMagnitude()
				if not minSm or sm <= minSm then
					minSm = sm
					closest = vertex
				end
			end
			normal = other:globalCenter(transform2) - closest
		end

		--if this is a polygon, we will check each side
		--if this is not a polygon, we will break at the end of the loop
		for i, vertex in ipairs(collider) do
			if icollider == 1 or otherType ~= Circle then
				normal = Vector.rotate(collider[i%len + 1] - vertex, 90)
			end

			--the vector might be (0,0) if the 2nd collider is a circle,
			--and the 1st collider is touching its center
			if normal.x == 0 and normal.y == 0 then
				return true
			end

			local normalAngle = normal:angle()

			local minPoint1 = nil
			local maxPoint1 = nil

			--project the first collider's vertices against the normal
			for _, vertex2 in ipairs(poly1Verts) do
				local projected = vertex2:project(normal)
				local adjustedProjected = projected:rotate(normalAngle)

				if not minPoint1 then
					minPoint1 = adjustedProjected
				end

				if not maxPoint1 then
					maxPoint1 = adjustedProjected
				elseif adjustedProjected.x < minPoint1.x then
					minPoint1 = adjustedProjected
				elseif adjustedProjected.x > maxPoint1.x then
					maxPoint1 = adjustedProjected
				end
			end

			local minPoint2 = nil
			local maxPoint2 = nil

			--project the second collider's vertices against the normal
			for _, vertex2 in ipairs(otherVerts) do
				local projected = vertex2:project(normal)
				local adjustedProjected = projected:rotate(normalAngle)

				if not minPoint2 then
					minPoint2 = adjustedProjected
				end

				if not maxPoint2 then
					maxPoint2 = adjustedProjected
				elseif adjustedProjected.x < minPoint2.x then
					minPoint2 = adjustedProjected
				elseif adjustedProjected.x > maxPoint2.x then
					maxPoint2 = adjustedProjected
				end
			end

			local points = {{minPoint1,1}, {minPoint2,2}, {maxPoint1,1}, {maxPoint2,2}}
			table.sort(points, function(a,b) return a[1].x < b[1].x end)

			--if the first two sorted points are from the same collider, we've found a gap
			--(unless the min of one is exactly the max of the other)
			if points[1][2] == points[2][2] and points[2][1].x ~= points[3][1].x then
				return false
			end

			--if this is a circle, there is only one "normal" to check, so we can break now
			if icollider == 2 and otherType == Circle then
				break
			end
		end
	end

	--if no gaps have been found, there must be a collision
	return true
end

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

function Polygon:globalPolygon(transform)
	return Polygon(self:globalVertices(transform))
end

function Polygon:contains(vector)
	return intersectingPolygonAndOther(self, vector)
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

    -- represent lines as P(t) = p + t*u (t in [0, 1])
    local p1, p2 = points1[1], points2[1]
    local u1, u2 = points1[2] - points1[1], points2[2] - points2[1]
    local v = p2 - p1

    -- solve P1(t1) = P2(t2): a bit of linear algebra here...

    local det = -u1.x*u2.y + u1.y*u2.x
    -- det == 0 means that edges are colinear, no intersection
    if det == 0 then return false end

    local t1 = (-u2.y*v.x - u2.x*v.y)/det
    local t2 = (-u1.y*v.x + u1.x*v.y)/det

    -- verify that t1 and t2 both lie in [0, 1]
    if t1 < 0 or t1 > 1 or t2 < 0 or t2 > 1 then return false end

    return true
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
    for _, side in ipairs(rect:sides()) do
        if intersectingEdges(edge, side, transform1, transform2) then
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
    local shape1Type = class.isInstanceOf(shape1, Vector, Rectangle, Circle, Edge)
    local shape2Type = class.isInstanceOf(shape2, Vector, Rectangle, Circle, Edge)

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
    intersecting = intersecting,
}
