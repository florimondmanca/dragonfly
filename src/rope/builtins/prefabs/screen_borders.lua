local w, h = love.graphics.getDimensions()

return {
    components = {
        {
            script = 'rope.builtins.colliders.polygon_collider',
            arguments = {
                group = 'screen_borders',
                points = {{x=0, y=0}, {x=w, y=0}, {x=w, y=h}, {x=0, y=h}}
            }
        },
        -- link to camera
        {script = 'rope.builtins.camera.link'}
    }
}
