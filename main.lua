-- Double commented code (----) is not a note, but removed code.
-- This is love2d, v11, not 10

-- Important and Constant variables.
SCREEN_MOD = 3.1
SCREEN_SIZE = {x=1080/SCREEN_MOD, y=1920/SCREEN_MOD}

FONT_SIZE = 64 / SCREEN_MOD
MAIN_FONT = love.graphics.newFont("consola.ttf", FONT_SIZE)

gDebugText = ""

function love.load()
    -- Images are loaded here.

    -- Set up the window.
    love.window.setMode(SCREEN_SIZE.x, SCREEN_SIZE.y, {resizable=false, vsync=true})
    love.window.setTitle("Image Recognition")
    love.graphics.setBackgroundColor(50/255, 50/255, 50/255, 255)

    -- Other Modules are loaded here.

    -- Any initialization code goes after here.
    love.graphics.setFont(MAIN_FONT)  -- Init the font.

    -- Load images.
    goatData = love.image.newImageData("images/cookie.png")

    -- Init modules.
    imageProcessor = require("imageProcessor")

    -- Initialization commands.
    img = imageProcessor.getBatchMapFromImage(goatData)
end

-- Only drawing and maybe come conditional statements go here.
function love.draw()
    --love.graphics.setColor(255, 255, 255, 255)
    --imageProcessor.drawImage(img)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(gDebugText, 100/SCREEN_MOD, 100/SCREEN_MOD)
end

-- No drawing code, Math or physics code goes here.
function love.update(dt)

end
