-- Double commented code (----) is not a note, but removed code.

-- Important and Constant variables.
SCREEN_SIZE = {x=1080/3.1, y=1920/3.1}

FONT_SIZE = 48
MAIN_FONT = love.graphics.newFont("consola.ttf", FONT_SIZE)

function love.load()
    -- Images are loaded here.

    -- Set up the window.
    love.window.setMode(SCREEN_SIZE.x, SCREEN_SIZE.y, {resizable=false, vsync=true})
    love.window.setTitle("Image Recognition")
    love.graphics.setBackgroundColor(50, 50, 50, 255)

    -- Other Modules are loaded here.

    -- Any initialization code goes after here.
    love.graphics.setFont(MAIN_FONT)  -- Init the font.

    -- Load images.
    goat = love.graphics.newImage("images/goat.jpg")

    -- Init modules
    imageProcessor = require("imageProcessor")

    img = imageProcessor.getBatchMapFromImage(goat)
end

-- Only drawing and maybe come conditional statements go here.
function love.draw()
    imageProcessor.drawImage(img)
end

-- No drawing code, Math or physics code goes here.
function love.update(dt)

end
