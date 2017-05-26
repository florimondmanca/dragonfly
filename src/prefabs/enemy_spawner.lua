return function(args) return {
    {
        script = 'components.enemy_spawner'
    },
    {
        script = 'rope.builtins.event.appear_trigger',
        arguments = {
            axis = args.axis,
            conditions = {below=args.below, above=args.above},
            event = args.event
        }
    },
    {
        script = 'rope.builtins.event.event_listener',
        arguments = {
            event = args.event,
            targetComponent = 'components.enemy_spawner',
            targetFunction = 'spawn'
        }
    },
}
end
