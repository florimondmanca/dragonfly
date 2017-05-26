-- Game entry point

local rope = require('rope')

local scene

function love.load()
    scene = rope.GameScene()
    scene:loadSettings('settings.lua')
    scene:load()
end

--- default callback functions for game entities.
local ENTITIES_CALLBACKS = {
    'update', 'draw',
    'keypressed', 'keyreleased',
    'mousepressed', 'mousemoved', 'mousereleased',
    'quit', 'windowresize', 'visible'
}

for _, f in ipairs(ENTITIES_CALLBACKS) do
    love[f] = function(...) scene[f](scene, ...) end
end
