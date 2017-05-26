local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('RectangleShape')

function Component:initialize(arguments)
    if not arguments.shapeFrom then
        self:require(arguments, 'width', 'height')
    else arguments.width, arguments.height = 1, 1 end
    arguments.debugColor = arguments.debugColor or {255, 0, 255}
    arguments.origin = geometry.Vector(arguments.origin)
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return self.shapeFrom and {source = {script = self.shapeFrom}} or {}
end

function Component:awake()
    self.shape = geometry.Rectangle(self.width, self.height, self.origin)
    if self.shapeFrom then self.shape:setFrom(self.source.shape) end
    self.width, self.height, self.origin = nil, nil, nil
    -- add debug rectangle renderer
    self.gameObject:buildAndAddComponent({
        script = 'rope.builtins.graphics.rectangle_renderer',
        arguments = {
            color = self.debugColor,
            mode = 'line',
            width = self.shape.width,
            height = self.shape.height,
            origin = self.shape.origin,
        },
        isDebug = true
    })
end


return Component
