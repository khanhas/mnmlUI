--[[

MoveTo segment, this indicates where the path should start and is the same as lifting the pen and moving it to a new location. (e.g starting a new Path shape)

Note: additional parameters after the initial point is counted as LineTo, hence the "pathSegments:L()"

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	local x = tonumber(parameters[1])
	local y = tonumber(parameters[2])
		if relative then
			x = x + pen.X
			y = y + pen.Y
		end
	local moveShape = nil
	if shape["path"] ~= nil and trim(shape["path"]) ~= "" then
		local newShape = {}
		newShape["modifiers"] = deepcopy(shape["modifiers"])
		newShape["shape"] = "Path Path" .. nextPath
		nextPath = nextPath + 1
		moveShape = newShape
	else
		moveShape = shape
	end
	moveShape["path"] = x .. ", " .. y
	pen.X = x
	pen.Y = y
	lastControlX = x2
	lastControlY = y2
	lastQuadraticX = nil
	lastQuadraticY = nil
	table.remove(parameters, 1)
	table.remove(parameters, 1)
	pathSegments.L(parameters, pen, moveShape, relative)
	return moveShape
end
