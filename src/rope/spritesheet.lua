local json = require 'rope.lib.json'
local lume = require 'rope.lib.lume'


----- loads the spritesheet and returns its image and the associated frames.
-- assumes that a <sheetName>.png and <sheetName>.json exist at given
-- sheetName location.
-- @tparam string sheetName the name of the sheet without extension.
-- @return image, quads, maxQuadWidth, maxQuadHeight
local function load(sheetName)
    local image = love.graphics.newImage(sheetName .. '.png')
    local frames = json.decode(love.filesystem.read(sheetName .. '.json'))
    local quads = {}
    local maxWidth, maxHeight = 0, 0
    lume.each(frames, function(frame)
        lume.push(quads, love.graphics.newQuad(
            frame.x, frame.y, frame.width, frame.height,
            image:getWidth(), image:getHeight())
        )
        if frame.width > maxWidth then maxWidth = frame.width end
        if frame.height > maxHeight then maxHeight = frame.height end
    end)
    return image, quads, maxWidth, maxHeight
end


return {
    load = load,
}
