local rope = require 'rope'

local Component = rope.Component:subclass('ComponentName')

function Component:initialize(arguments)
    -- manipulate, validate and fetch arguments here.
    -- (use `self:require(arguments, '<arg1Name>', '<arg2Name>', ...)` to
    -- mark arguments as mendatory and throw error if they were not given.)
    -- every field of the arguments table will be accessible through `self`
    -- after initialize().
    rope.Component.initialize(self, arguments)
end

function Component:worksWith()
    -- explicitly require other components that this component need to
    -- work with. example:
    -- `return {collider = {script = '<collider_script>'}}`
    -- you will then be able to access the collider component has `self.collider`.
end

function Component:awake()
    -- called after the component is added to a Game Object,
    -- use for extra setup that requires access to the game object.
end

function Component:update(dt, firstUpdate)
    -- update the component here.
    -- firstUpdate is true only during the first game frame.
end

function Component:draw(debug)
    -- draw the component here.
    -- add additional debug rendering if debug is true.
end

return Component
