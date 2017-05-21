local rope = require 'rope'

-- --------------
-- -- QuadTree --
-- --------------
--
-- local QuadTree = class('QuadTree')
-- QuadTree.static.DEFAULT_MAX_OBJECTS = 10
-- QuadTree.static.DEFAULT_MAX_LEVEL = 5
-- QuadTree.static.CHILD_NODES = 4
-- QuadTree.static.CHILD_NODES_SQRT = 2
-- QuadTree.static.NW = 1
-- QuadTree.static.NE = 2
-- QuadTree.static.SW = 3
-- QuadTree.static.SE = 4
-- QuadTree.static.PARENT = -1
--
-- function QuadTree:initialize(rect, level, maxObjects, maxLevel)
--     self.rect = rect
--     self.boundary = nil
--     self.chidNodes = {}
--     self.objects = {}
--     self.level = level
--     self.maxObjects = maxObjects or QuadTree.DEFAULT_MAX_OBJECTS
--     self.maxLevel = maxLevel or QuadTree.DEFAULT_MAX_LEVEL
-- end
--
-- function QuadTree:clear()
--     self.objects = {}
--     for _, node in ipairs(self.childNodes) do
--         node:clear()
--     end
-- end
--
-- function QuadTree:subdivide()
--     assert(self.level < self.maxLevel, 'subdividing more would exceed max level')
--
-- 	local child_w = self.rect.w / QuadTree.CHILD_NODE_SQRT
-- 	local child_h = self.rect.h / QuadTree.CHILD_NODE_SQRT
--
-- 	local x = self.rect.x
-- 	local y = self.rect.y
--
-- 	self.childNodes:insertAt(QuadTree.NW,
--         QuadTree(Rect(x, y, child_w, child_h), self.level + 1, self.maxObjects, self.maxLevel)
--     )
-- 	self.childNodes:insertAt(QuadTree.NE,
--         QuadTree(Rect(x + child_w, y, child_w, child_h), self.level + 1, self.maxObjects, self.maxLevel)
--     )
-- 	self.childNodes:insertAt(QuadTree.SW,
--         QuadTree(Rect(x, y + child_h, child_w, child_h), self.level + 1, self.maxObjects, self.maxLevel)
--     )
-- 	self.childNodes:insertAt(QuadTree.SE,
--         QuadTree(Rect(x+ child_w, y + child_h, child_w, child_h), self.level + 1, self.maxObjects, self.maxLevel)
--     )
-- end


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
    local collided = (rect2.x - rect1.w < rect1.x and rect1.x < rect2.x + rect2.w)
    and (rect2.y - rect1.h < rect1.y and rect1.y < rect2.y + rect2.h)
    return collided
end


return {
    collideRect = collideRect,
}
