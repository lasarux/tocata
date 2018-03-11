FIGURE = {}
local CONFIG = {} -- to keep it separate from the global env

local f, err = loadfile("objects.lua", "t", CONFIG)
if CONFIG then
    f() -- run the chunk
    -- now configEnv should contain your data
else
    print(err)
end


lastkey = ''
-- scale = 8
GREEN = {0x60, 0x90, 0xd0, 255}
BLACK = {0, 0, 0, 255}
WHITE = {255, 255, 255, 255}
CAPS = false
KANGOROO = {0xb3, 0xa5, 0xd8, 0xff}
F = GREEN
B = BLACK
TOP = 20
LANG = "en"


local function has_value (tab, val)
    for index, value in pairs(tab) do
        -- We grab the first index of our sub-table instead
        if index == val then
            return true
        end
    end

    return false
end

function love.load()
    -- first load
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
    font_small = love.graphics.newFont("fonts/8-BIT WONDER.TTF", 18)
    -- Font = love.graphics.newFont("Minecraftia-Regular.ttf", 120)
    Font:setFilter( "nearest", "nearest", 1)
    sound = love.audio.newSource("sounds/tap.mp3", "static")
    
end



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
    if figure_current then
        love.graphics.print(figure_current[1], 20, 170, 0, 1, 1)
    end
    love.graphics.setFont(Font)
    love.graphics.print(lastkey, 210, 70, 0, 1, 1)

    love.graphics.setColor(WHITE)
    -- love.graphics.draw(background, 0, 0);
    if figure_current then
        love.graphics.draw(figure_current[2], 30, 50)
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'capslock' then
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
        figure_current = {c["l10n"][LANG], love.graphics.newImage(c["image"])}
    end

    --avoid multi keys
    if string.len(key) > 1 then
        key = lastkey
    end
    lastkey = key
    sound:stop()
    sound:play()
  
end