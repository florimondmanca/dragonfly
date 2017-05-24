-- local w, h = love.graphics.getDimensions()

return {
    components = {
        -- borders
        {
            script = 'rope.builtins.colliders.edge_collider',
            arguments = {
                point1 = {x=500, y=0},
                point2 = {x=400, y=600}
            }
        },
        -- link to camera
        {script = 'rope.builtins.camera.link'}
    }
}
