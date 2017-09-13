--[[

the Vertical LineTo segment is one or multiple vertical lines 

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters do
		local y = tonumber(parameters[i])
		if relative then
			y = y + pen.Y
		end
		shape["path"] = shape["path"] .. " | LineTo " .. pen.X .. ", " .. y 
		pen.Y = y
		lastControlX = x2
		lastControlY = y2
		lastQuadraticX = nil
		lastQuadraticY = nil
	end
end