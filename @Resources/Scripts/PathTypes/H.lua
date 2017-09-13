--[[

the Horizontal LineTo segment is one or multiple horizontal lines 

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters do
		local x = tonumber(parameters[i])
		if relative then
			x = x + pen.X
		end
		shape["path"] = shape["path"] .. " | LineTo " .. x .. ", " .. pen.Y
		pen.X = x
		lastControlX = x2
		lastControlY = y2
		lastQuadraticX = nil
		lastQuadraticY = nil
	end
end