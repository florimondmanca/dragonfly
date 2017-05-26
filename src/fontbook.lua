local lume = require 'rope.lib.lume'

lume.trace('building font book')

----- the font book memorizes past accesses to a font and size
local fontbook = {}

-- all available fonts
local fonts = {
    -- name = font (assumed to be in 'static/font/' directory)
    pixel = 'pixelfont.ttf',
    title = 'millennia.ttf',
}
-- set the default font here
fonts.default = fonts.pixel

-- gets a font from the font book (if it doesn't exist in required size, it
-- is created)
local function _getFont(font, size)
    if not fontbook[font] then
        fontbook[font] = {}
    end
    if not fontbook[font][size] then
        fontbook[font][size] = love.graphics.newFont('static/font/' .. font, size)
    end
    return fontbook[font][size]
end

-- gets a font from the font book, checking that the name exists first
function fontbook.get(name, size)
    name = name or 'default'
    size = size or 12
    local font = fonts[name]
    assert(font, 'font ' .. name .. ' is not in the font book')
    return _getFont(font, size)
end

return fontbook
