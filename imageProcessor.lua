local ImageProcessor = {}

-- Holds the position of the image.
imagePosition = {x=SCREEN_SIZE.x/2, y=SCREEN_SIZE.y/2}

-- A list of all the batch images.
batchList = {}

-- A list of all the pixels that don't need to be turned into a batch.
completePixelList = {}

-- Draws the image on the screen.
function ImageProcessor.drawImage(image)
    love.graphics.draw(image, imagePosition.x - image:getWidth()/4, imagePosition.y - image:getHeight()/4, 0, 0.5, 0.5)
end

function makeBatchFromPixel(oldData, x, y)
    local pixelMatrix = {}

    local batchData = love.image.newImageData( oldData:getWidth(), oldData:getHeight() )

    -- Loop through each pixel.
    for xIndex=0, oldData:getWidth()-1, 1 do
        for yIndex=0, oldData:getHeight()-1, 1 do
            batchData:setPixel( xIndex, yIndex, 10, 70, 200, 255 )
        end
    end

    -- Get the first pixel.
    --local pixel = data:getPixel(x, y)
    --pixelMatrix[x][y] = pixel

    table.insert(batchList, batchData)

    gDebugText = gDebugText .. "0"

    -- save the batch?
    --love.filesystem.write("test.png", batchData)
    --batchData:encode("png", x .. '*' .. y .. ".png" )
end

-- This function returns all the batches mashed together as an image.
function ImageProcessor.getBatchMapFromImage(image)
    local position = {x=0, y=0}

    -- Is image ok? key == "e" and
    if not image:isCompressed() then
        gDebugText = gDebugText .. "Probably fine"
    else
        gDebugText = gDebugText .. "Not Ok, Badness"
    end

    -- Create the new and old image data variables.
    imgData = image:getData()
    local newData = love.image.newImageData( image:getWidth(), image:getHeight() )

    -- Loop through each pixel.
    for x=0, image:getWidth()-1, 1 do
        for y=0, image:getHeight()-1, 1 do
            makeBatchFromPixel(imgData, x, y)
        end
    end

    -- TODO: make the image by attaching the batches together.
    --local newImage = love.graphics.newImage( newData )

    return newImage
end

return ImageProcessor
