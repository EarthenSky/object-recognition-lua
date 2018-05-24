local ImageProcessor = {}

-- Holds the position of the image.
imagePosition = {x=SCREEN_SIZE.x/2, y=SCREEN_SIZE.y/2}

-- A list of all the batch images and colours.
batchList = {}
batchColourList = {}

-- A staring that holds of all the pixels that don't need to be turned into a batch. (string)
pixels = {}

-- A list of all the pixels that don't need to be turned into a batch.
completePixelList = {}

-- Draws the image on the screen.
function ImageProcessor.drawImage(image)
    love.graphics.draw(image, imagePosition.x - image:getWidth()/4, imagePosition.y - image:getHeight()/4, 0, 0.5, 0.5)
end

-- Use a modifier to check if the second colour is inside the bounds of the most different modified colour permeutations.
function checkPixelSimilarity(colourModify, colourCompare, modifier)
    --[[
    max_similarity = modifier

    -- Find the value differences from the main colour of each secondary colour.
    red_diff = math.abs(colourCompare.r - colourModify.r)
    green_diff = math.abs(colourCompare.g - colourModify.g)
    blue_diff = math.abs(colourCompare.b - colourModify.b)

    if (red_diff + green_diff + blue_diff) < max_similarity then
        return true
    end
    ]]

    if colourCompare.r <= colourModify.r / modifier and colourCompare.r >= colourModify.r * modifier then
        if colourCompare.g <= colourModify.g / modifier and colourCompare.g >= colourModify.g * modifier then
            if colourCompare.b <= colourModify.b / modifier and colourCompare.b >= colourModify.b * modifier then
                return true
            end
        end
    end

    return false
end

-- TODO?: change the COLOUR_SIMILARITY_MOD to be a value?
COLOUR_SIMILARITY_MOD = 0.80 --0.45

-- This is a recursive function. pos = {x=x, y=y}
function checkAdjacentPixels(readData, OG_COLOUR, pos)
    -- Exit the function if this piexl has already been added to the list.
    local check_pos = {x=-1, y=-1}
    local last_value = '-'

    -- Loop all the pixels in the batch.
    for i, value in ipairs(pixels) do

        if last_value == 'x' then
            check_pos.x = value
        elseif last_value == 'y' then
            check_pos.y = value

            -- Check for case: this pixel has already been put in the list.
            if check_pos.x == pos.x and check_pos.y == pos.y then
                return  -- Stop processing this pixel.
            end
        end

        -- Set the last char
        last_value = value
    end

    local check_pos = {x=-1, y=-1}
    local last_value = '-'

    -- Loop all the pixels in completePixelList too.
    for i, value in ipairs(completePixelList) do

        if last_value == 'x' then
            check_pos.x = value
        elseif last_value == 'y' then
            check_pos.y = value

            -- Check for case: this pixel has already been put in the list.
            if check_pos.x == pos.x and check_pos.y == pos.y then
                return  -- Stop processing this pixel.
            end
        end

        -- Set the last char
        last_value = value
    end

    -- Find the colour of this pixel.
    local r,g,b,a = readData:getPixel(pos.x, pos.y)
    if checkPixelSimilarity(OG_COLOUR, {r=r, g=g, b=b, a=a}, COLOUR_SIMILARITY_MOD) == true then

        -- This is the base condition.  Every pixel needs to do this.  Add the piexls to a temp list.
        table.insert(pixels, 'x')
        table.insert(pixels, pos.x)
        table.insert(pixels, 'y')
        table.insert(pixels, pos.y)

        -- Add this pixel to the main list. (not just for this batch)
        table.insert(completePixelList, 'x')
        table.insert(completePixelList, pos.x)
        table.insert(completePixelList, 'y')
        table.insert(completePixelList, pos.y)

        if pos.x > 0 then
            checkAdjacentPixels( readData, OG_COLOUR, {x=pos.x-1, y=pos.y} )  -- Check left pixel.
        end

        if pos.x < 49 then
            checkAdjacentPixels( readData, OG_COLOUR, {x=pos.x+1, y=pos.y} )  -- Check right pixel.
        end

        if pos.y > 0 then
            checkAdjacentPixels( readData, OG_COLOUR, {x=pos.x, y=pos.y-1} )  -- Check top pixel.
        end

        if pos.y < 49 then
            checkAdjacentPixels( readData, OG_COLOUR, {x=pos.x, y=pos.y+1} )  -- Check bottom pixel.
        end
    else
        --print "bad colour ret"
        return
    end
end

function makeBatchFromPixel(readData, x, y)
    -- Exit the function if this pixel has already been added to completePixelList.
    local check_pos = {x=-1, y=-1}
    local last_value = '-'

    -- Loop all the pixels in the batch.
    for i, value in ipairs(completePixelList) do
        if last_value == 'x' then
            check_pos.x = value
        elseif last_value == 'y' then
            check_pos.y = value

            -- Check for case: this pixel has already been put in the list.
            if check_pos.x == x and check_pos.y == y then
                return  -- Exit this function
            end
        end

        -- Set the last char
        last_value = value
    end

    -- The pixel data for this batch.
    batchData = love.image.newImageData( readData:getWidth(), readData:getHeight() )

    -- Set init pixel data.
    for xIndex=0, batchData:getWidth()-1, 1 do
        for yIndex=0, batchData:getHeight()-1, 1 do
            batchData:setPixel( xIndex, yIndex, 0, 0, 0, 255 )
        end
    end

    -- Reset the pixel list before using it and Fill the pixel list
    -- with the value of the pixels that are in the batch.
    pixels = {}
    r,g,b,a = readData:getPixel(x, y)
    checkAdjacentPixels( readData, {r=r, g=g, b=b, a=a}, {x=x, y=y} )

    -- This converts the list into imgData.
    local pixel_pos = {x=-1, y=-1}
    local last_value = '-'

    -- Loop all the pixels in the batch.
    for i, value in ipairs(pixels) do
        if last_value == 'x' then
            pixel_pos.x = tonumber(value)

        elseif last_value == 'y' then
            pixel_pos.y = tonumber(value)

            batchData:setPixel( pixel_pos.x, pixel_pos.y, readData:getPixel(pixel_pos.x, pixel_pos.y) )
        end

        -- Set the last char equal to the current char.
        last_value = value
    end

    -- add batch to be processed later.
    table.insert(batchList, batchData)
    table.insert(batchColourList, {r=r, g=g, b=b, a=a})
end

-- This modifier handles how similar a colour has to be to another one to be put together.
MASH_COLOUR_SIMILARITY_MOD = 0.7

-- This function returns all the batches mashed together as an image.
function ImageProcessor.getBatchMapFromImage(imgData)
    -- Reset the batch list before using it.
    batchList = {}
    batchColourList = {}

    completePixelList = {}  -- Reset the used pixels before using them.

    -- Create the image data variable for outputing the batch of batches.
    local outData = love.image.newImageData( imgData:getWidth(), imgData:getHeight() )

    -- Loop through each pixel.
    for x=0, imgData:getWidth()-1, 1 do
        for y=0, imgData:getHeight()-1, 1 do
            makeBatchFromPixel(imgData, x, y)
        end
    end

    -- The list that holds similarly coloured batches.
    mashedBatchList = {}  -- {d=data, c=colour (r,g,b,a)}

    -- Loop through all the batches and combine them.
    for i, data in ipairs(batchList) do
        -- Check if this colour exists yet.  If it does exist add the batch to the colour's batch.  If not add it to the list.
        addToList = true
        for i2, table in ipairs(mashedBatchList) do
            -- TODO: CHOOSE BEST FIT HERE
            if checkPixelSimilarity(batchColourList[i], table.c, MASH_COLOUR_SIMILARITY_MOD) == true then
                -- Place the two images.
                for xIndex=0, table.d:getWidth()-1, 1 do
                    for yIndex=0, table.d:getHeight()-1, 1 do
                        r,g,b,a = table.d:getPixel( xIndex, yIndex )

                        r2,g2,b2,a2 = data:getPixel( xIndex, yIndex )
                        r2,g2,b2 = r2 * a2, g2 * a2 ,b2 * a2  -- Apply the opacity to the piexl before adding it.

                        table.d:setPixel( xIndex, yIndex, r + r2, g + g2, b + b2, a )
                    end
                end

                addToList = false

                break  -- Break from for loop?
            end
        end

        -- Add to list.
        if addToList == true then
            --print("insert")
            table.insert(mashedBatchList, {d=data, c=batchColourList[i]})
        end
    end

    -- Loop through all the batches and output them.
    for i, obj in ipairs(mashedBatchList) do
        print ("" .. i)
        obj.d:encode("png", i .. "--" .. "r" .. tonumber(obj.c.r*255) .. "g" .. tonumber(obj.c.g*255) .. "b" .. tonumber(obj.c.b*255) .. ".png")
    end

    -- TODO: make the batch image by attaching the batches together.
    --local newImage = love.graphics.newImage( outData )

    return newImage
end

return ImageProcessor
