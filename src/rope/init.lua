local class = require 'rope.class'
local geometry = require 'rope.geometry'
local collections = require 'rope.collections'


--[[ Component ]]--

local Component = class('Component')

function Component:initialize(arguments)
    self.gameObject = nil
    for k, v in pairs(arguments or {}) do
        self[k] = v
    end
end

function Component:validate(arguments, ...)
    arguments = arguments or {}
    for _, argName in ipairs{...} do
        if arguments[argName] == nil then
            error(argName .. ' must be declared for component ' .. tostring(self) .. ', nil given')
        end
    end
end

function Component:setGameObject(gameObject)
    self.gameObject = gameObject
    self.globals = gameObject.globals
    if self.awake then self:awake() end
end

function Component:update() end

local function loadComponent(filename)
    local componentClass = require(filename)
    assert(componentClass, 'Could not find component at ' .. filename)
    return componentClass
end


-- [[ Game Entity ]] --

local GameEntity = class('GameEntity')

function GameEntity:initialize(transform, parent)
    transform = transform or {}
    if transform.class == geometry.Transform then
        self.transform = transform
    else
        self.transform = geometry.Transform(transform)
    end
    self.children = {}
    if parent then
        parent:addChild(self)
    end
end

function GameEntity:addChild(child, trackParent)
    assert(child:isInstanceOf(GameEntity), 'child must be a GameEntity')
    assert(child ~= self, 'circular reference: cannot add self as child')

    if trackParent == nil then trackParent = true end

    if self.children then
        table.insert(self.children, child)
    else
        self.children = {child}
    end

    if trackParent then child.parent = self end
end

function GameEntity:update(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

-- Default callback functions
for _, f in ipairs{'keypressed', 'keyreleased', 'mousepressed', 'mousemoved',
'mousereleased', 'quit', 'windowresize', 'visible'} do
    GameEntity[f] = function(self, ...)
        for _, child in ipairs(self.children) do
            child[f](child, ...)
        end
    end
end


--[[ GameObject ]]--

local function getComponents(self, componentType, num, filter)
    filter = filter or function() return true end
    if type(componentType) == 'string' then
        componentType = require(componentType)
        assert(componentType, 'Component ' .. tostring(componentType) .. ' does not exist')
    end
    local found = {}
    for _, component in ipairs(self.components) do
        if component:isInstanceOf(componentType) and filter(component) then
            table.insert(found, component)
        end
        if #found >= num then return found end
    end
    return found
end

local GameObject = GameEntity:subclass('GameObject')

function GameObject:initialize(scene, name, transform)
    self.globals = scene.globals
    self.name = name
    GameEntity.initialize(self, transform, scene)
    self.components = {}
    scene:addGameObject(self)
end

function GameObject:update(dt)
    for _, component in ipairs(self.components) do
        component:update(dt)
    end
    GameEntity.update(self, dt)
end

function GameObject:draw()
    for _, component in ipairs(self.components) do
        if component.draw then component:draw() end
    end
end

function GameObject:addComponent(component)
    assert(component:isInstanceOf(Component), "Trying to add non-Component object to object's components")
    table.insert(self.components, component)
    component:setGameObject(self)
end

function GameObject:removeComponent(componentClass)
    for i, c in ipairs(self.components) do
        if c:isInstanceOf(componentClass) then
            return table.remove(self.components, i)
        end
    end
end

function GameObject:getComponent(componentType, filter)
    return getComponents(self, componentType, 1, filter)[1] or
        error('No component ' .. tostring(componentType) .. ' found' ..
        (filter and ' with conditions ' .. tostring(filter) or ''))
end

function GameObject:getComponents(componentType, filter)
    return getComponents(self, componentType, nil, filter)
end

function GameObject:destroy()
    self.parent:destroy(self)
end

-- Default callback functions
for _, f in ipairs{'keypressed', 'keyreleased', 'mousepressed', 'mousemoved',
'mousereleased', 'quit', 'windowresize', 'visible'} do
    GameObject[f] = function(self, ...)
        for _, component in ipairs(self.components) do
            if component[f] then component[f](component, ...) end
        end
        GameObject.super[f](self, ...)
    end
end


-- [[ GameScene ]] --

-- Helpers
local function createSettingsTable(settings, defaults)
    settings = settings or {}
    defaults = defaults or require('rope.defaults')

    -- assign defaults for fields not defined in settings
    for sectionName, section in pairs(defaults) do
        -- assign non-defined sections
        if not settings[sectionName] then
            settings[sectionName] = section
        -- if section is defined, assign its non-defined options
        else
            if type(section) == 'table' then
                for optionName, option in pairs(section) do
                    if not settings[sectionName][optionName] then
                        settings[sectionName][optionName] = option
                    end
                end
            -- some sections are not tables,
            -- in this case, only assure that the value is well defined
            else
                settings[sectionName] = settings[sectionName] or section
            end
        end
    end
    return settings
end

local function getPrefabComponents(object)
    local prefabTable = require(object.prefab)
    local components = {}
    for _, component in ipairs(prefabTable.components) do
        table.insert(components, component)
    end
    if object.prefabComponents then
        for _, component in ipairs(components) do
            for _, overridden in ipairs(object.prefabComponents) do
                if component.script == overridden.script then
                    for k, v in pairs(overridden.arguments) do
                        component.arguments[k] = v
                    end
                end
            end
        end
    end
    return components
end

local function buildObject(scene, object)
    -- create the game object
    local gameObject = GameObject(scene, object.name, object.transform)
    -- get components from prefab if given
    if object.prefab then
        assert(type(object.prefab) == 'string', 'Prefab must be a string')
        object.components = object.components or {}
        for _, component in ipairs(getPrefabComponents(object)) do
            table.insert(object.components, component)
        end
    end
    -- add components
    for _, component in ipairs(object.components) do
        local componentClass = require(component.script)
        assert(componentClass.isSubclassOf and
        componentClass:isSubclassOf(Component), 'Script ' .. component.script .. ' does not return a Component')
        gameObject:addComponent(componentClass(component.arguments or {}))
    end
    return gameObject
end

local GameScene = GameEntity:subclass('GameScene')

function GameScene:initialize(name, transform)
    self.name = name or 'GameScene'
    self.gameObjects = {}
    self.globals = {}
    self.globals.scene = self
    GameScene.super.initialize(self, transform)
end

function GameScene:addGameObject(gameObject)
    assert(gameObject:isInstanceOf(GameObject), "Trying to add non-GameObject to the GameScene")
    table.insert(self.gameObjects, gameObject)
end

function GameScene:destroy(gameObject)
    self.toDestroy = self.toDestroy or {}
    table.insert(self.toDestroy, gameObject)
end

function GameScene:removeGameObject(gameObject)
    local index = collections.index(self.gameObjects, gameObject)
	if index then
		table.remove(self.gameObjects, index)
	end
    local index2 = collections.index(self.children, gameObject)
	if index2 then
		table.remove(self.children, index2)
	end

	for k in pairs(gameObject) do
		gameObject[k] = nil
	end
end


function GameScene:loadSettings(settingsFile)
    self.settings = createSettingsTable(love.filesystem.load(settingsFile)())
end

function GameScene:applySettings()
    -- window
    love.window.setMode(self.settings.window.width, self.settings.window.height)
    love.window.setTitle(self.settings.window.title or 'Untitled')
    -- graphics
    love.graphics.setBackgroundColor(self.settings.graphics.backgroundColor)
end

function GameScene:load(src)
    local typeS = type(src)
    local source = ''

    -- load the source game scene file if necessary
    if typeS == 'nil' then
        assert(self.settings, [[Settings not defined.
        You must call scene:loadSettings(settingsFilename) before
        scene:load().]])
        source = self.settings.firstScene
        assert(source ~= '', 'First scene not declared.')
        src = love.filesystem.load(source)()
    elseif typeS == 'string' then
        source = src
        src = love.filesystem.load(source)()
    else
        assert(typeS == 'table', 'src must be filename, module name or table')
        assert(src.gameObjects, 'src.gameObjects is required')
        assert(src.settings, 'src.settings is required')
    end

    self:initialize(src.name)
    self.source = source

    -- scene settings
    self.settings = createSettingsTable(src.settings, self.settings)
    self:applySettings()

    -- load game objects
    for _, object in ipairs(src.gameObjects) do
        buildObject(self, object)
    end
end

function GameScene:update(dt)
    GameScene.super.update(self, dt)
    for _, gameObject in ipairs(self.toDestroy or {}) do
        self:removeGameObject(gameObject)
    end
    self.toDestroy = {}
end

function GameScene:draw()
    for _, object in ipairs(self.gameObjects) do
        object:draw()
    end
end


---

return {
    Component = Component,
    GameObject = GameObject,
    GameScene = GameScene,
    loadComponent = loadComponent
}
