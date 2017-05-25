local json = require 'rope.lib.json'


----- loads the spritesheet and returns its image and the associated frames.
-- assumes that a <sheetName>.png and <sheetName>.json exist at given
-- sheetName location.
-- @tparam string sheetName the name of the sheet without extension.
local function load(sheetName)
    local image = love.graphics.newImage(sheetName .. '.png')
    local frames = json.decode(love.filesystem.read(sheetName .. '.json'))
    local quads = {}
    for _, frame in ipairs(frames) do
        table.insert(quads, love.graphics.newQuad(
            frame.x, frame.y, frame.width, frame.height,
            image:getWidth(), image:getHeight())
        )
    end
    return image, quads
end


return {
    load = load,
}
