local rope = require 'rope'
local lume = require 'rope.lib.lume'
local asserts = require 'rope.asserts'


local Trigger = rope.Component:subclass('Trigger')

----- initializes an appear trigger
-- appear triggers trigger events when its owner's X or Y position gets above
-- or below a certain value. useful for enemy spawners.
-- @tparam string axis ('x' or 'y')
-- @tparam table conditions as `{above=<abovePos>, below=<belowPos>}`.
-- @tparam string event the event to trigger.
-- @tparam bool destroyOnCondition if `true`, the owner will be destroyed after
-- the first time event is triggered.
function Trigger:initialize(arguments)
    self:require(arguments, 'axis', 'conditions', 'event')
    arguments.destroyOnCondition = arguments.destroyOnCondition == nil and true or false
    asserts.isIn({'x', 'y'}, arguments.axis, 'axis')
    rope.Component.initialize(self, arguments)
end

function Trigger:update()
    local coord = self.gameObject.globalTransform.position[self.axis]
    if coord > (self.conditions.above or math.huge) or coord < (self.conditions.below or -math.huge) then
        local e = self.globals.events[self.event]
        assert(e, 'Trigger could not find event ' .. self.event)
        e:trigger(self)
        if self.destroyOnCondition then self.gameObject:destroy() end
    end
end

function Trigger:awake()
    -- add debug renderers
    local x1, y1, x2, y2
    if self.axis == 'x' then
        x1, y1 = 0, 0
        x2, y2 = 0, love.graphics.getHeight()
    else
        x1, y1 = 0, 0
        x2, y2 = love.graphics.getWidth(), 0
    end
    self.gameObject:buildAndAddComponents({
        {
            script = 'rope.builtins.graphics.edge_renderer',
            arguments = {
                color = {0, 255, 0},
                point1 = {x=x1, y=y1},
                point2 = {x=x2, y=y2}
            },
            isDebug = true
        },
        {
            script = 'rope.builtins.graphics.text_renderer',
            arguments = {
                text = lume.wordwrap(lume.format(
                    '{name}{above}{below}',
                    {
                        name = self.gameObject.name,
                        above = self.conditions.above
                            and lume.format(' (above: {value})', {value=self.conditions.above})
                            or '',
                        below = self.conditions.below
                            and lume.format(' (below: {value})', {value=self.conditions.below})
                            or '',
                    }
                ), 20),
                fontSize = 9,
                color = {0, 255, 0}
            },
            isDebug = true
        }
    })
end

return Trigger
