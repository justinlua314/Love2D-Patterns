shutter = {
	shots = {
		requested = 0,
		remaining = 0
	},

	patternFunction = nil,
	albumName = "Untitled",
	fileType = ".png",
	tickerReset = 0.5,

	-- This value doesn't really matter as your storage speed will surely be the bottleneck.
	ticker = 0.5
}

function shutter.doScreenshot()
	love.filesystem.createDirectory("albums/" .. shutter.albumName)

	love.graphics.captureScreenshot("albums/"
	.. shutter.albumName .. "/"
	.. tostring(shutter.shots.requested - shutter.shots.remaining)
	.. shutter.fileType)
end

function shutter.update(dt)
	if shutter.shots.requested == 0 then return end
	shutter.ticker = (shutter.ticker - dt)

	if shutter.ticker <= 0 then
		shutter.ticker = shutter.tickerReset
		shutter.shots.remaining = (shutter.shots.remaining - 1)
		print("\tRendered " .. tostring(shutter.shots.requested - shutter.shots.remaining) .. "/" .. tostring(shutter.shots.requested))
		shutter.doScreenshot()
		if shutter.shots.remaining == 0 then shutter.shots.requested = 0 end
		pattern.clear()
		shutter.patternFunction()
		pattern.render()
	end
end

function shutter.generateImage(patternFunction, albumName, times)
	if type(patternFunction) ~= "function" then
		print("Shutter Error: Pattern given to shutter is not a function.")
		return
	end

	times = times or 1
	if type(times) ~= "number" then times = 1 end
	if albumName then shutter.albumName = albumName end

	shutter.shots.requested = times
	shutter.shots.remaining = times
	shutter.patternFunction = patternFunction
	print("Rendering album '" .. albumName .. "'")
	pattern.clear()
	shutter.patternFunction()
	pattern.render()
end
