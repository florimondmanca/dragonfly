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

----- creates a new collision with a collider
function Collider:newCollision(other)
    self.collisions[other] = {resolved = false}
end

function Collider:resolved(collider)
    self.collisions[collider].resolved = true
    print('resolved collision with', collider.gameObject.name)
end

----- registers a collision with another collider for the current time frame.
-- you may override this in specialized components to, for example, filter
-- the collisions based on some condition
-- @tparam Collider other
function Collider:addCollision(other)
    self:newCollision(other)
end

----- updates the collider by removing resolved collisions.
function Collider:update()
    local collisions = {}
    for collider, collision in pairs(self.collisions) do
        if not collision.resolved then collisions[collider] = collision end
    end
    self.collisions = collisions
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
