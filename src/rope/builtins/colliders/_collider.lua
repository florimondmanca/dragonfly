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

----- closes a collision.
-- NOTE: should be called once a collision is resolved (e.g. in a resolver)
-- @tparam Collider collider
function Collider:resolved(collider)
    self.collisions[collider] = self.collisions[collider] - 1
    -- collider.collisions[self] = collider.collisions[self] - 1
end

function Collider:newCollision(collider)
    if not self.collisions[collider] then
        self.collisions[collider] = 0
    end
    self.collisions[collider] = self.collisions[collider] + 1
end

----- registers a collision with another collider for the current time frame.
-- NOTE: you may override this in specialized components to, for example,
-- filter the collisions based on some condition.
-- @tparam Collider collider
function Collider:addCollision(collider)
    if self:acceptsCollisionWith(collider)
    and collider:acceptsCollisionWith(self) then
        -- print('detected collision between', self.gameObject.name, 'and', collider.gameObject.name)
        self:newCollision(collider)
        collider:newCollision(self)
    end
end

----- callback function for collision acceptance
-- must return true if collision with given other collider is accepted, false otherwise.
-- returns true by default.
-- @tparam Collider otherCollider
function Collider:acceptsCollisionWith()
    return true
end

----- updates the collider by removing resolved collisions.
function Collider:update()
    for collider, collisions in pairs(self.collisions) do
        if collisions <= 0 then self.collisions[collider] = nil end
    end
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
