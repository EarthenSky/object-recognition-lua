function love.load()
  --load initial imagedata
  imagedata = love.image.newImageData("images/cookie.png")

  --save file
  love.filesystem.setIdentity("imagedata")

  file = love.filesystem.newFile("imagedata.dat")
  file:open('w')
  file:write(imagedata:encode("png")) --save it as a bitmap. "tga", targa, is also availible.
  file:close()

  file = io.open("out/woah.png", "w+")
  file:write(tostring(goatData)) --data is the filedata of the image dragged and dropped

  --to make sure we're not cheating
  imagedata = nil
  --load imagedata again
  imagedata = love.image.newImageData("imagedata.dat")
  image = love.graphics.newImage(imagedata)
end

function love.draw()
  love.graphics.draw(image,0,0)
end
