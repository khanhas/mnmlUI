--[[

the Simplified Quadratic Curve segment is one or multiple simple quadratic bezier curves

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function(parameters, pen, shape, relative)
	for i=1, #parameters, 2 do
		local x  = tonumber(parameters[i])
		local y  = tonumber(parameters[i+1])
		if relative then
			x = x + pen.X
			y = y + pen.Y
		end

		if lastQuadraticX == nil then
			lastQuadraticX = x2
		end
		if lastQuadraticY == nil then
			lastQuadraticY = y2
		end

		shape["path"] = shape["path"] .. " | CurveTo " .. x .. ", " .. y .. ", " .. lastQuadraticX .. ", " .. lastQuadraticY

		if relative then
			x = x - pen.X
			y = y - pen.Y
		end
		lastControlX = nil
		lastControlY = nil
		lastQuadraticX = lastQuadraticX + (x - lastQuadraticX) * 2
		lastQuadraticY = lastQuadraticY + (y - lastQuadraticY) * 2
		
		if relative then
			x = x + pen.X
			y = y + pen.Y
			lastControlX = lastControlX + pen.X
			lastControlY = lastControlY + pen.Y
		end

		pen.X = x
		pen.Y = y
	end
end