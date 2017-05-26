return {
    name = 'MenuScene',
    settings = {
        graphics = {
            backgroundColor = {50, 50, 60},
        },
    },
    gameObjects = {
        {
            name = 'FPS',
            transform = {position = {x = 30, y = 30}},
            prefab = 'rope.builtins.prefabs.fps_renderer',
            isDebug = true
        },
        {
            name = 'EventManager',
            components = {
                {
                    script = 'rope.builtins.event.event_manager',
                    arguments = {events = {'start'}}
                },
            }
        },
        {
            name = 'Title',
            transform = {
                position = {x = love.graphics.getWidth()/2, y = 100}
            },
            components = {
                {
                    script = 'rope.builtins.graphics.text_renderer',
                    arguments = {
                        text = 'DragonFly',
                        font = 'title',
                        fontSize = 64,
                        alignCenter = true
                    }
                }
            }
        },
        -- buttons
        {
            name = 'Play button',
            transform = {position = {x = love.graphics.getWidth()/2, y = 300}},
            prefab = 'prefabs.text_button',
            prefabComponents = {
                {
                    script = 'rope.builtins.graphics.text_renderer',
                    arguments = {
                        text = 'Play',
                        fontSize = 16,
                    }
                },
            }
        },
        {
            name = 'Quit button',
            transform = {position = {x = love.graphics.getWidth()/2, y = 400}},
            prefab = 'prefabs.text_button',
            prefabComponents = {
                {
                    script = 'rope.builtins.graphics.text_renderer',
                    arguments = {text = 'Quit'}
                },
            }
        },
    },
}
