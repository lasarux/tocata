-- initial vars
FIGURE = {}
local CONFIG = {} -- to keep it separate from the global env

lastkey = ''
s = nil

GREEN = {0x60, 0x90, 0xd0, 255}
BLACK = {0, 0, 0, 255}
WHITE = {255, 255, 255, 255}
CAPS = false
KANGOROO = {0xb3, 0xa5, 0xd8, 0xff}
F = GREEN
B = BLACK
TOP = 30
LANG = "es"

-- function to check keys in a table
local function has_value (tab, val)
    for index, value in pairs(tab) do
        -- We grab the first index of our sub-table instead
        if index == val then
            return true
        end
    end

    return false
end

-- first run
function love.load()
    -- first load
    f, err = love.filesystem.load("objects.lua")
    setfenv(f, CONFIG)
    f()
    
    n = "a" .. math.random(TOP)
    c = CONFIG[n]
    if c["l10n"][LANG] and c["l10n"][LANG][2] then
        figure_current = {
            c["l10n"][LANG][1], love.graphics.newImage(c["image"]), love.audio.newSource(c["l10n"][LANG][2], "static")
        }
    else
        figure_current = {
            c["l10n"][LANG], love.graphics.newImage(c["image"]), ""
        }
    end
    time = love.timer.getTime()
    word_played = false


    love.window.setMode(320,200, {highdpi=high_dpi, fullscreen=true})

    high_dpi = love.window.getPixelScale()
    screen_modes = love.window.getFullscreenModes()
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()


    if high_dpi then
        scalex = window_width / 320
        scaley = window_height / 200
    else
        scalex = (window_width / 320) / 2
        scaley = (window_height / 200) / 2
    end
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.scale(scale, scale)

    love.mouse.setVisible(false)
    
    -- Font = love.graphics.newFont("retro_computer.ttf", 120)
    Font = love.graphics.newFont("fonts/8-BIT WONDER.TTF", 72)
    font_small = love.graphics.newFont("fonts/8-BIT WONDER.TTF", 15)
    -- Font = love.graphics.newFont("Minecraftia-Regular.ttf", 120)
    Font:setFilter( "nearest", "nearest", 1)
    sound = love.audio.newSource("sounds/tap.mp3", "static")
    
end

-- draw new frame
function love.draw()
    -- love.graphics.setCanvas(canvas)
    love.graphics.setFont(Font)
    love.graphics.scale(scalex, scaley)

    love.graphics.setColor(KANGOROO)
    love.graphics.polygon("fill", 0,0,160,0,160,320,0,320,0,0 )

    -- background = love.graphics.newImage(imageData)

    -- love.graphics.draw(imageFile, 50, 50)
    love.graphics.setBackgroundColor(B)
    -- love.graphics.clear()
    love.graphics.setColor(WHITE)
    love.graphics.setFont(font_small)
    print (figure_current[1])
    if figure_current then
        local width = font_small:getWidth(figure_current[1])
        love.graphics.print(figure_current[1], (160 - width) / 2, 170, 0, 1, 1)
    end
    love.graphics.setFont(Font)
    love.graphics.print(lastkey, 210, 70, 0, 1, 1)

    love.graphics.setColor(WHITE)
    -- love.graphics.draw(background, 0, 0);
    if figure_current then
        love.graphics.draw(figure_current[2], 30, 50)
    end
    if (love.timer.getTime() - time) > 2 and not word_played then
        if figure_current[3] ~= "" then
            figure_current[3]:play()
            word_played = true
        end
    end
end

-- check key pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "rshift" then
        c = CONFIG[n]
        if c["sound"] then
            if s then
                s:stop()
            end
            s = love.audio.newSource(c["sound"], "static")
            s:play()
        end
        return
    elseif key == "lshift" then
        if LANG == "es" then
            LANG = "en"
        else
            LANG = "es"
        end
        -- TODO: create a function to load resources
        c = CONFIG[n]
        if c["l10n"][LANG] and c["l10n"][LANG][2] then
            figure_current = {
                c["l10n"][LANG][1], love.graphics.newImage(c["image"]), love.audio.newSource(c["l10n"][LANG][2], "static")
            }
        else
            figure_current = {
                c["l10n"][LANG], love.graphics.newImage(c["image"]), ""
            }
        end
        time = love.timer.getTime()
        word_played = false
        key = lastkey
        return
    elseif key == "capslock" then
        CAPS = not CAPS
        if CAPS then
            F = BLACK
            B = GREEN
        else
            F = GREEN
            B = BLACK
        end
    elseif key ~= lastkey then
        n = "a" .. math.random(TOP)
        c = CONFIG[n]
        -- load resources (text, image and pronunciation)
        if c["l10n"][LANG] and c["l10n"][LANG][2] then
            figure_current = {
                c["l10n"][LANG][1], love.graphics.newImage(c["image"]), love.audio.newSource(c["l10n"][LANG][2], "static")
            }
        else
            figure_current = {
                c["l10n"][LANG], love.graphics.newImage(c["image"]), ""
            }
        end
        time = love.timer.getTime()
        word_played = false
    end

    --avoid multi keys
    if string.len(key) > 1 then
        key = lastkey
    end
    lastkey = key
    time = love.timer.getTime()
    -- stop playing object sound
    if s then
        s:stop()
    end
    -- play key stroke without echo
    sound:stop()
    sound:play()
end
