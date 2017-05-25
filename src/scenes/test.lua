return {
    name = 'TestScene',
    settings = {
        graphics = {
            backgroundColor = {150, 150, 150},
        },
    },
    gameObjects = {
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer',
            isDebug = true,
        },
        {
            name = 'Sprite',
            components = {
                {
                    script = 'rope.builtins.graphics.sprite_animation',
                    arguments = {
                        sheetName = 'static/sheets/bird',
                        fps = 30,
                    },
                },
                {script = 'rope.builtins.mouse.link'}
            }
        },
    }
}
