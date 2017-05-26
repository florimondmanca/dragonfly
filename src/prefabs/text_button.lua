return {
    components = {
        {
            script = 'rope.builtins.graphics.text_renderer',
            arguments = {text = 'Button', alignCenter = true}
        },
        {
            script = 'rope.builtins.colliders.rectangle_collider',
            arguments = {
                shapeFrom = 'rope.builtins.graphics.text_renderer',
            }
        },
    }
}
