local rope = require 'rope'
local class = require 'rope.class'
local geometry = require 'rope.geometry'
local asserts = require 'rope.asserts'

local Collider = rope.Component:subclass('Collider')

----- base class for all collider components
-- do not use this as a component directly! (unless you cn think of a good reason to)
-- @tparam Shape shape (required)
-- @tparam string group a collider groups to attach the owner to (eg enemies, bullets, etc).
function Collider:initialize(arguments)
    self:require(arguments, 'shape')
    asserts.isInstanceOf(geometry.Shape, arguments.shape, 'shape')
    rope.Component.initialize(self, arguments)
    self.collisions = {}
end

----- registers a collision with another collider for the current time frame.
-- @tparam Collider other
function Collider:addCollision(other)
    table.insert(self.collisions, other)
end

----- updates the collider.
-- calls resolve() on each collision encountered in this frame.
-- @tparam number dt delta time as passed to love.update()
function Collider:update(dt)
    for _, collider in ipairs(self.collisions) do
        self:resolve(collider, dt)
    end
    self.collisions = {}
end

----- resolves a collision with another collider.
-- this is a callback function that should be set in resolver components
-- @tparam Collider collider
-- @tparam dt delta time as passed to love.update()
function Collider:resolve()
    -- callback function
end

----- tests if collider collides with another collider, shape or point.
-- @param other Collider, Shape or Vector
-- @return true in case of collision, false otherwise
function Collider:collidesWith(other)
	local otherType = class.isInstanceOf(other, Collider, geometry.Shape, geometry.Vector)
	assert(otherType, 'other must be a Collider, Shape, or Vector')
	if otherType == Collider then
		return geometry.intersecting(
			self.shape, other.shape, self.gameObject.globalTransform, other.gameObject.globalTransform
		)
	else
		return geometry.intersecting(self.shape, other, self.gameObject.globalTransform)
	end
end

return Collider
