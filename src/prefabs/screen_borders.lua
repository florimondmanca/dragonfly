local padx, pady = 0, 20

return function(w, h) return
unpack({
    {
        name = 'Screen border top',
        transform = {position = {x=padx, y=-20 + pady}},
        components = {
            {
                script = 'rope.builtins.shapes.rectangle',
                arguments = {
                    width = w - 2*padx,
                    height = 20,
                }
            },
            {
                script = 'rope.builtins.colliders.rectangle_collider',
                arguments = {
                    group = 'screen_borders',
                    static = true,
                }
            },
            {
                script = 'components.colliders.ignore_groups',
                arguments = {groups = {screen_borders = true}}
            },
            {script = 'rope.builtins.camera.link'}
        }
    },
    {
        name = 'Screen border right',
        transform = {position = {x=w - padx, y=pady}},
        components = {
            {
                script = 'rope.builtins.shapes.rectangle',
                arguments = {
                    width = 20,
                    height = h - 2*pady,
                }
            },
            {
                script = 'rope.builtins.colliders.rectangle_collider',
                arguments = {
                    group = 'screen_borders',
                    static = true,
                }
            },
            {
                script = 'components.colliders.ignore_groups',
                arguments = {groups = {screen_borders = true}}
            },
            {script = 'rope.builtins.camera.link'}
        }
    },
    {
        name = 'Screen border bottom',
        transform = {position = {x=padx, y=h-pady}},
        components = {
            {
                script = 'rope.builtins.shapes.rectangle',
                arguments = {
                    width = w - 2*padx,
                    height = 20,
                }
            },
            {
                script = 'rope.builtins.colliders.rectangle_collider',
                arguments = {
                    group = 'screen_borders',
                    static = true,
                }
            },
            {
                script = 'components.colliders.ignore_groups',
                arguments = {groups = {screen_borders = true}}
            },
            {script = 'rope.builtins.camera.link'}
        }
    },
    {
        name = 'Screen border left',
        transform = {position = {x=-20 + padx, y=pady}},
        components = {
            {
                script = 'rope.builtins.shapes.rectangle',
                arguments = {
                    width = 20,
                    height = h - 2*pady,
                }
            },
            {
                script = 'rope.builtins.colliders.rectangle_collider',
                arguments = {
                    group = 'screen_borders',
                    static = true,
                }
            },
            {
                script = 'components.colliders.ignore_groups',
                arguments = {groups = {screen_borders = true}}
            },
            {script = 'rope.builtins.camera.link'}
        }
    },
})
end
