local rope = require 'rope'
local class = require 'rope.class'
local lume = require 'rope.lib.lume'
local geometry = require 'rope.geometry'

local Collider = rope.Component:subclass('Collider')


----- a base class for all colliders
-- do not use directly.
-- @tparam string group a collider groups to attach the owner to (eg enemies, bullets, etc).
function Collider:initialize(arguments)
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
    self.collisions = lume.reject(self.collisions,
        function(c) return c <= 0 end, true)
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
