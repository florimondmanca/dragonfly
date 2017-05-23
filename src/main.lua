-- Game entry point

local rope = require('rope')

local scene

function love.load()
    scene = rope.GameScene()
    scene:loadSettings('settings.lua')
    scene:load()
end

function love.update(...)
    scene.update(scene, ...)
end

function love.draw(...)
    scene.draw(scene, ...)
end

function love.mousepressed(...)
    scene.mousepressed(scene, ...)
end

function love.keypressed(...)
    scene.keypressed(scene, ...)
end

function love.quit(...)
    scene.quit(scene, ...)
end
