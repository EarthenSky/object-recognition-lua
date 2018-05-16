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

    -- The pixel data for this batch.
    local batchData = love.image.newImageData( oldData:getWidth(), oldData:getHeight() )

    -- Loop through each pixel.
    for xIndex=0, oldData:getWidth()-1, 1 do
        for yIndex=0, oldData:getHeight()-1, 1 do
            batchData:setPixel( xIndex, yIndex, 10/255, 70/255, 200/255, 255/255 )
        end
    end

    -- Get the first pixel.
    --local pixel = data:getPixel(x, y)
    --pixelMatrix[x][y] = pixel

    table.insert(batchList, batchData)

    -- save the batch
    batchData:encode("png", "x.png")

end

-- This function returns all the batches mashed together as an image.
function ImageProcessor.getBatchMapFromImage(imgData)
    -- Reset the batch list before using it.
    batchList = {}

    local position = {x=0, y=0}

    -- Create the image data variable for outputing the batch of batches.
    local outData = love.image.newImageData( imgData:getWidth(), imgData:getHeight() )

    -- Loop through each pixel.
    for x=0, imgData:getWidth()-1, 1 do
        for y=0, imgData:getHeight()-1, 1 do
            makeBatchFromPixel(imgData, x, y)
        end
    end

    -- Loop through all the batches.
    for i, p in ipairs(batchList) do

    end

    -- TODO: make the image by attaching the batches together.
    --local newImage = love.graphics.newImage( outData )

    return newImage
end

return ImageProcessor
