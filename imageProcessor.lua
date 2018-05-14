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

function makeBatchFromPixel(data, x, y)

end

-- This function returns all the batches mashed together as an image.
function ImageProcessor.getBatchMapFromImage(image)
    position = {x=0, y=0}

    -- Create the image.
    if key == "e" and not image:isCompressed() then
        data = image:getData()

        newData = love.image.newImageData( image:getWidth(), image:getheight())

        --data:mapPixel(function(x, y, r, g, b, a) return r/2, g/2, b/2, a/2 end)
        --image:refresh()
    else
       print "Badness"
    end

    -- Loop through each pixel.
    -- HOW DO FOR LOOPS?
    for x in image:getWidth() do
        for y in image:getHeight() do
            readPixel(data, x, y)
        end
    end

    newImage = love.graphics.newImage( newData )

    return newImage

end

return ImageProcessor
