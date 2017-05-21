local rope = require 'rope'
local class = require 'rope.class'


-------------------------
-- Auxiliary functions --
-------------------------

--- tests if a table has rect-like attributes (x, y, w > 0, h > 0).
-- @tparam table table
-- @raise error if table doesn't provide rect-like attributes.
local function assertIsRect(table)
    rope.assertType('number', table.x, 'x')
    rope.assertType('number', table.y, 'y')
    rope.assertIsPositiveNumber(table.w, 'w')
    rope.assertIsPositiveNumber(table.h, 'h')
end

--- tests if a rect collides with another one.
-- @tparam Rect rect1
-- @tparam Rect rect2
-- @return true if rect1 and rect2 collide, false otherwise.
local function collideRect(rect1, rect2)
    assertIsRect(rect1)
    assertIsRect(rect2)
    return (rect2.x - rect1.w < rect1.x and rect1.x < rect2.x + rect2.w)
    and (rect2.y - rect1.h < rect1.y and rect1.y < rect2.y + rect2.h)
end

----------
-- Rect --
----------

local Rect = class('Rect')

--- initializes a rect.
-- @tparam number x
-- @tparam number y
-- @tparam number w rectangle width (must be strictly positive).
-- @tparam number h rectangle height (must be strictly positive).
function Rect:initialize(x, y, w, h)
    assertIsRect{x=x, y=y, w=w, h=h}
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

--- tests if rect collides with another rect
-- @tparam Rect other another rect
-- @return true if rect and other collide, false otherwise.
function Rect:collide(other)
    return collideRect(self, other)
end


return {
    Rect = Rect,
    collideRect = collideRect,
}
