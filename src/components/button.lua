local rope = require 'rope'
local geometry = require 'rope.geometry'

local Component = rope.Component:subclass('Button')

function Component:initialize(arguments)
    self:require(arguments, 'button')
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    return {rectangle = {script = 'components.rectangle_shape'}}
end

function Component:action()
    print('action!')
end

function Component:mousepressed(x, y, button)
    if button == self.button and
    geometry.intersecting(self.rectangle.shape, geometry.Vector(x, y), self.gameObject.globalTransform) then
        self:action()
    end
end


return Component
