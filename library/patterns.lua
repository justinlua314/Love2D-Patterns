pattern = {
	canvas = love.graphics.newCanvas(global.width, global.height),
	list = {},

	colors = {
		rainbow = {
			{0.8, 0.15, 0.15},
			{0.93, 0.25, 0},
			{1, 0.9, 0},
			{0.49, 1, 0},
			{0.4, 0.71, 1},
			{0.6, 0.2, 0.8}
		}
	},
}

function pattern.new(name, data)
	data.type = name
	table.insert(pattern.list, data)
end

function pattern.reset()
	pattern.list = {}
end

function pattern.clear()
	pattern.list = {}
end

function pattern.randomColor()
	local color = {
		(love.math.random(100) / 100),
		(love.math.random(100) / 100),
		(love.math.random(100) / 100)
	}

	return color
end

function pattern.randomColors(amount)
	local t = {}

	for i = 1, amount do
		table.insert(t, pattern.randomColor())
	end

	return t
end

function pattern.randomWords(amount)
	amount = amount or 1
	local words = {}

	local pulledVolumes = {}
	local t = {}

	for i = 1, amount do
		table.insert(t, love.math.random(47))
	end

	for _,selection in pairs(t) do
		if not pulledVolumes[selection] then
			print("Rendering new dictionary number " .. selection .. "...")
			local s = love.filesystem.read("dictionary/dic" .. selection .. ".txt")
			pulledVolumes[selection] = global.explodeString(s, "\n")
		end
		
		local w = pulledVolumes[selection][love.math.random(#pulledVolumes[selection])]
		table.insert(words, w)
	end

	return words
end

function pattern.randomCoordinates()
	local coordinates = {x = love.math.random(global.width), y = love.math.random(global.height)}
	return coordinates
end

function pattern.drawLine(colors, thickness, location, direction, rotation, lines, height)
	thickness = thickness or 1
	location = location or {x = 0, y = 0}
	direction = direction or "forward"
	rotation = rotation or 0
	lines = lines or math.ceil((global.width * 1.5) / thickness)
	height = height or math.ceil(global.height * 1.5)

	local currentColor = 1

	for column = 1, lines do
		if colors == "random" then
			love.graphics.setColor(pattern.randomColor())
		else
			love.graphics.setColor(colors[currentColor])
			currentColor = (currentColor + 1)
			if currentColor > #colors then currentColor = 1 end
		end

		love.graphics.polygon("fill",
		location.x, location.y,
		(location.x + thickness), location.y,
		(location.x - rotation + thickness), location.y + height,
		location.x - rotation, location.y + height)

		if direction == "forward" then
			location.x = (location.x + thickness)
		else
			location.x = (location.x - thickness)
		end
	end
end

function pattern.drawSpiral(colors, thickness, location, direction, rotation, limit)
	colors = colors or "random"
	thickness = thickness or 1
	location = location or
	{x = math.floor(global.width / 2), y = math.floor(global.height / 2)}

	direction = direction or 1
	rotation = rotation or 1
	local length = (thickness * 2)

	if type(colors) == "table" then
		-- Extra fluff to allow the scripter to use a single color or two
		if type(colors[2]) == "table" then
			love.graphics.setColor(colors[1])
			love.graphics.clear(colors[2])
		else
			love.graphics.setColor(colors)
		end
	elseif colors == "random" then
		love.graphics.setColor(pattern.randomColor())
	end

	local check = true

	while check do
		--[[
		direction:
		1 = up
		2 = right
		3 = down
		4 = left

		A rotation of 1 means clockwise, a rotation of 2 means counter-clockwise.]]
		if direction == 1 then
			if rotation == 1 then direction = 2 else direction = 4 end
			love.graphics.rectangle("fill", location.x, location.y, thickness, (length * -1))
			location.y = (location.y - length)
		elseif direction == 2 then
			if rotation == 1 then direction = 3 else direction = 1 end
			love.graphics.rectangle("fill", location.x, location.y, (length + thickness), thickness)
			location.x = (location.x + length)
		elseif direction == 3 then
			if rotation == 1 then direction = 4 else direction = 2 end
			love.graphics.rectangle("fill", location.x, location.y, thickness, (length + thickness))
			location.y = (location.y + length)
		elseif direction == 4 then
			if rotation == 1 then direction = 1 else direction = 3 end
			love.graphics.rectangle("fill", location.x, location.y, (length * -1), thickness)
			location.x = (location.x - length)
		end
		length = (length + thickness)

		if limit == "screen" and location.x <= global.width and location.x >= 0 and location.y <= global.height and location.y >= 0 then check = false end
		if type(limit) == "number" and length > limit then check = false end
		if not limit and length > (global.width + global.height) then check = false end
	end
end

function pattern.drawNoise(colors, details, density, spread, shade, shape)
	details = details or {x = 0, y = 0, width = 100, height = 100}
	density = density or 1
	spread = spread or 1
	shape = shape or "rectangle"

	for column = 1, details.height, density do
		for row = 1, details.width, density do
			local highlight = 1

			if shade then
				highlight = love.math.noise(love.math.random())
				if highlight < shade then highlight = shade end
			end

			local col = colors[love.math.random(#colors)]
			table.insert(col, 4, highlight)
			love.graphics.setColor(col)

			local xPoint = (details.x + row)
			local yPoint = (details.y + column)

			if shape == "rectangle" then
				love.graphics.rectangle("fill", xPoint, yPoint, love.math.random(spread), love.math.random(spread))
			elseif shape == "circle" then
				love.graphics.circle("fill", xPoint, yPoint, love.math.random(spread))
			end
		end
	end
end

function pattern.drawWordPlot(colors, details, words, size)
	details = details or {x = 0, y = 0, width = global.width, height = global.height}
	words = words or pattern.randomWords(10)
	size = size or {min = 10, max = 20}

	if type(colors[1]) ~= "table" then love.graphics.setColor(colors) end

	for _,word in pairs(words) do
		if type(colors[1]) == "table" then
			love.graphics.setColor(colors[love.math.random(#colors)])
		end

		love.graphics.setNewFont(love.math.random(size.min, size.max))
		love.graphics.printf(word,
		love.math.random(details.x, (details.x + details.width)),
		love.math.random(details.y, (details.y + details.height)),
		10000)
	end
end

function pattern.render()
	love.graphics.setCanvas(pattern.canvas)
		love.graphics.clear(0, 0, 0)

		for _,draw in pairs(pattern.list) do
			if draw.type == "lines" then
				pattern.drawLine(draw.colors, draw.thickness, draw.location, draw.direction, draw.rotation, draw.lines, draw.height)
			elseif draw.type == "spiral" then
				pattern.drawSpiral(draw.colors, draw.thickness, draw.location, draw.direction, draw.rotation, draw.limit)
			elseif draw.type == "noise" then
				pattern.drawNoise(draw.colors, draw.details, draw.density, draw.spread, draw.shade, draw.shape)
			elseif draw.type == "wordPlot" then
				pattern.drawWordPlot(draw.colors, draw.details, draw.words, draw.size)
			end
		end

	love.graphics.setCanvas()
end
