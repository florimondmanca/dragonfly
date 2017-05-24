local w, h = love.graphics.getDimensions()

return {
    components = {
        -- borders
        {
            script = 'rope.builtins.graphics.edge_renderer',
            arguments = {
                point1 = {x = 0, y = 0},
                point2 = {x = w, y = 0}
            }
        },
        {
            script = 'rope.builtins.graphics.edge_renderer',
            arguments = {
                point1 = {x = w, y = 0},
                point2 = {x = w, y = h}
            }
        },
        {
            script = 'rope.builtins.graphics.edge_renderer',
            arguments = {
                point1 = {x = w, y = h},
                point2 = {x = 0, y = h}
            }
        },
        {
            script = 'rope.builtins.graphics.edge_renderer',
            arguments = {
                point1 = {x = 0, y = h},
                point2 = {x = 0, y = 0}
            }
        },
        -- link to camera
        {script = 'rope.builtins.camera.link'}
    }
}
