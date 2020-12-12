memeText = {
	top = "", bottom = "", image = nil,
	font1 = nil, font2 = nil
}

function memeText.load()
	memeText.font1 = love.graphics.newFont("fonts/impact.ttf", 40)
	memeText.font2 = love.graphics.newFont("fonts/impact.ttf", 39)
end

function memeText.draw()
	-- Text is rendered twice in two similar fonts to give a black border effect on the letters
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(memeText.font1)
	love.graphics.printf(memeText.top, 0, 50, global.width, "center")
	love.graphics.printf(memeText.bottom, 0, (global.height - 100), global.width, "center")

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(memeText.font2)
	love.graphics.printf(memeText.top, 0, 50, global.width, "center")
	love.graphics.printf(memeText.bottom, 0, (global.height - 100), global.width, "center")

	if memeText.image then
		love.graphics.draw(memeText.image,
		((global.width / 2) - (memeText.image:getWidth() / 2)),
		((global.height / 2) - (memeText.image:getHeight() / 2)))
	end
end

function memeText.generate()
	local top, bottom
	local f

	f = love.filesystem.read("library/topText.txt")
	f = global.explodeString(f, "\n")
	top = f[love.math.random(#f)]

	f = love.filesystem.read("library/bottomText.txt")
	f = global.explodeString(f, "\n")
	bottom = f[love.math.random(#f)]

	return top, bottom
end

function memeText.setText(top, bottom)
	top = top or "Top Text"
	bottom = bottom or "Bottom Text"

	memeText.top = top
	memeText.bottom = bottom
end

function memeText.setImage(location)
	memeText.image = love.graphics.newImage(location)
end
