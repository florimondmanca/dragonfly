return {
    name = 'FPS',
    components = {
        {
            script = 'rope.builtins.graphics.text_renderer',
        },
        {
            script = 'rope.builtins.time.fps_computer',
        },
        -- link to camera
        {
            script = 'rope.builtins.camera.link'
        },
    }
}
