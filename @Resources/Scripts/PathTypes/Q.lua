--[[

the Quadratic Curve segment is one or multiple quadratic bezier curves

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters, 4 do
		local x1 = tonumber(parameters[i])
		local y1 = tonumber(parameters[i+1])
		local x  = tonumber(parameters[i+2])
		local y  = tonumber(parameters[i+3])
		if relative then
			x1 = x1 + pen.X
			y1 = y1 + pen.Y
			x = x + pen.X
			y = y + pen.Y
		end
		shape["path"] = shape["path"] .. " | CurveTo " .. x .. ", " .. y .. ", " .. x1 .. ", " .. y1
		if relative then
			x = x - pen.X
			y = y - pen.Y
			x1 = x1 - pen.X
			y1 = y1 - pen.Y
		end
		lastControlX = nil
		lastControlY = nil
		lastQuadraticX = x1 + (x - x1) * 2
		lastQuadraticY = y1 + (y - y1) * 2
		
		if relative then
			x = x + pen.X
			y = y + pen.Y
			lastQuadraticX = lastQuadraticX + pen.X
			lastQuadraticY = lastQuadraticY + pen.Y
		end
		pen.X = x
		pen.Y = y
	end
end