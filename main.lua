Fonts = { }

require "screens"
require "settings"
require "table-save"

function love.load()
    math.randomseed(os.time())
    math.random() math.random() math.random()

    Fonts["reg-16"] = love.graphics.newFont("assets/8bit-Regular.ttf", 16)
    Fonts["bold-12"] = love.graphics.newFont("assets/8bit-Bold.ttf", 12)
    Fonts["bold-16"] = love.graphics.newFont("assets/8bit-Bold.ttf", 16)
    Fonts["bold-24"] = love.graphics.newFont("assets/8bit-Bold.ttf", 24)
    Fonts["bold-48"] = love.graphics.newFont("assets/8bit-Bold.ttf", 48)

    love.window.setTitle("NERDConsole")
    love.keyboard.setKeyRepeat(true)

    CurrentScreen = Screens["mainmenu"]
    CurrentScreen:onEnter()
end

function love.update(dt)
    CurrentScreen:update(dt)
end

function love.draw()
    CurrentScreen:draw()
end

function love.keypressed(key)
    CurrentScreen:keypressed(key)
end

function love.textinput(key)
    CurrentScreen:textinput(key)
end

function love.quit()
    CurrentScreen:onExit()
    CurrentScreen = nil

    -- Save game
    local err = table.save(Systems, "systems-save.lua")
    if err then print("Error: " .. err) end
    err = table.save(Settings, "settings-save.lua")
    if err then print("Error: " .. err) end
end
