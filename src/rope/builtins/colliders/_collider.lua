local rope = require 'rope'
local class = require 'rope.class'
local geometry = require 'rope.geometry'
local asserts = require 'rope.asserts'

local Collider = rope.Component:subclass('Collider')

----- base class for all collider components
-- do not use this as a component directly! (unless you cn think of a good reason to)
-- @tparam Shape shape
function Collider:initialize(arguments)
    self:require(arguments, 'shape')
    asserts.isInstanceOf(geometry.Shape, arguments.shape, 'shape')
    rope.Component.initialize(self, arguments)
end

----- tests if collider collides with another collider, shape or point
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
