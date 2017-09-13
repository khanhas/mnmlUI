--[[

the Simple Curve segment is one or multiple simplified bezier curves

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters, 4 do
		local x2 = tonumber(parameters[i])
		local y2 = tonumber(parameters[i+1])
		local x  = tonumber(parameters[i+2])
		local y  = tonumber(parameters[i+3])
		if relative then
			x2 = x2 + pen.X
			y2 = y2 + pen.Y
			x = x + pen.X
			y = y + pen.Y
		end

		if lastControlX == nil then
			lastControlX = x2
		end
		if lastControlY == nil then
			lastControlY = y2
		end

		shape["path"] = shape["path"] .. " | CurveTo " .. x .. ", " .. y .. ", " .. lastControlX .. ", " .. lastControlY .. ", " .. x2 .. ", " .. y2 

		if relative then
			x = x - pen.X
			y = y - pen.Y
			x2 = x2 - pen.X
			y2 = y2 - pen.Y
		end
		lastControlX = x2 + (x - x2) * 2
		lastControlY = y2 + (y - y2) * 2
		lastQuadraticX = nil
		lastQuadraticY = nil
		
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