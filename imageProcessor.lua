local ImageProcessor = {}

-- Holds the position of the image.
imagePosition = {x=SCREEN_SIZE.x/2, y=SCREEN_SIZE.y/2}

-- A list of all the batch images.
batchList = {}

-- A list of all the pixels that don't need to be turned into a batch.
pixels = {}

-- A list of all the pixels that don't need to be turned into a batch.
completePixelList = {}

-- Draws the image on the screen.
function ImageProcessor.drawImage(image)
    love.graphics.draw(image, imagePosition.x - image:getWidth()/4, imagePosition.y - image:getHeight()/4, 0, 0.5, 0.5)
end

-- Use a modifier to check if the second colour is inside the bounds of the most different modified colour permeutations.
function checkPixelSimilarity(colourModify, colourCompare, modifier)
    if colourCompare.r < colourModify.r / 0.8 and colourCompare.r > colourModify.r * 0.8 then
        if colourCompare.g < colourModify.g / 0.8 and colourCompare.g > colourModify.g * 0.8 then
            if colourCompare.g < colourModify.b / 0.8 and colourCompare.b > colourModify.b * 0.8 then
                return true
            end
        end
    end

    return false
end

-- TODO?: change the COLOUR_SIMILARITY_MOD to be a value?
COLOUR_SIMILARITY_MOD = 0.8  -- This mod is from the og colour.

-- This is a recursive function. pos = {x=x, y=y}
function checkAdjacentPixels(OG_COLOUR, pos)

    --TODO: dont choose a pixel you allready chose.

    -- Find the colour of this pixel.
    this_pixel_colour = data:getPixel(pos.x, pos.y)
    if checkPixelSimilarity(OG_COLOUR, this_pixel_colour, COLOUR_SIMILARITY_MOD) == true then
        if pos.x > 0 then
            return checkAdjacentPixels( OG_COLOUR, {x=pos.x-1, y=pos.y} ) + pos  -- Check left pixel.
        elseif pos.x < SCREEN_SIZE.x then
            return checkAdjacentPixels( OG_COLOUR, {x=pos.x+1, y=pos.y} ) + pos  -- Check right pixel.
        elseif pos.y > 0 then
            return checkAdjacentPixels( OG_COLOUR, {x=pos.x, y=pos.y-1} ) + pos  -- Check top pixel.
        elseif pos.y < SCREEN_SIZE.y then
            return checkAdjacentPixels( OG_COLOUR, {x=pos.x, y=pos.y+1} ) + pos  -- Check bottom pixel.
        end
    end

-- TODO: THIS ADD TO LIST,. NOT PASS AS RETURN VALUE.  no return VALUESSSS.!!!
    -- This is the base condition.  when there are no more pixels left.
    --pixels.add() "x" .. pos.x .. "y" .. pos.y
end

function makeBatchFromPixel(readData, x, y)
    local pixelMatrix = {}

    -- The pixel data for this batch.
    local batchData = love.image.newImageData( readData:getWidth(), readData:getHeight() )

    -- TODO: REMOVE THIS.
    -- set init pixel data?
    for xIndex=0, batchData:getWidth()-1, 1 do
        for yIndex=0, batchData:getHeight()-1, 1 do
            batchData:setPixel( xIndex, yIndex, 0, 0, 0, 0 )
        end
    end

    -- Get the first pixel.
    --local pixel = data:getPixel(x, y)
    --pixelMatrix[x][y] = pixel

    -- Creates the pixel list
    checkAdjacentPixels( data:getPixel(x, y), {x=x, y=y} )

    batch_pixels_list = {}

    --TODO: convert list into imgData.

    -- add batch to be processed later.
    table.insert(batchList, batchData)
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
            --makeBatchFromPixel(imgData, x, y)
        end
    end

    -- one batch
    makeBatchFromPixel(imgData, 30, 25)

    -- Loop through all the batches.
    for i, data in ipairs(batchList) do
        print ("" .. i)
        data:encode("png", "" .. i .. ".png")
    end

    -- TODO: make the image by attaching the batches together.
    --local newImage = love.graphics.newImage( outData )

    return newImage
end

return ImageProcessor
