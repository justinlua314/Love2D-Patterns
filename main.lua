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

	pattern.render()
end

function love.update(dt)
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(pattern.canvas, 0, 0)
end

function love.keypressed(key)
end

function love.mousemoved(x, y)
end
