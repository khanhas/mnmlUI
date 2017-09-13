--[[

the LineTo segment is one or multiple lines 

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters, 2 do
		local x = tonumber(parameters[i])
		local y = tonumber(parameters[i+1])
		if relative then
			x = x + pen.X
			y = y + pen.Y
		end
		shape["path"] = shape["path"] .. " | LineTo " .. x .. ", " .. y 
		pen.X = x
		pen.Y = y
		lastControlX = x2
		lastControlY = y2
		lastQuadraticX = nil
		lastQuadraticY = nil
	end
end