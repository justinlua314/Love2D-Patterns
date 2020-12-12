require("libraries")

function love.load()
	pattern.new("spiral", {
		colors = {pattern.randomColor(), pattern.randomColor()},
		thickness = 20,
		location = {x = 800, y = 300},
		limit = 1600
	})

	pattern.new("line", {
		colors = {
			pattern.randomColor(),
			pattern.randomColor(),
			pattern.randomColor(),
			pattern.randomColor(),
			pattern.randomColor(),
		},
		thickness = 10,
		lines = 10,
		height = 200
	})

	pattern.new("noise", {
		colors = pattern.colors.rainbow,
		details = {x = 0, y = 201, width = 600, height = love.graphics.getHeight()},
		density = 5,
		spread = 10,
		shade = 0.2
	})

	pattern.render()
end

function love.update(dt)
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(pattern.canvas, 0, 0)
end
