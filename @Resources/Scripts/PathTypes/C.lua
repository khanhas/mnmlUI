--[[

the Curve segment is one or multiple bezier curves

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters, 6 do
		--if parameters[i] ~= nil and parameters[i+1] ~= nil and parameters[i+2] ~= nil and parameters[i+3] ~= nil and parameters[i+4] ~= nil and parameters[i+5] ~= nil then
			local x1 = tonumber(parameters[i])
			local y1 = tonumber(parameters[i+1])
			local x2 = tonumber(parameters[i+2])
			local y2 = tonumber(parameters[i+3])
			local x  = tonumber(parameters[i+4])
			local y  = tonumber(parameters[i+5])
			if relative then
				x1 = x1 + pen.X
				y1 = y1 + pen.Y
				x2 = x2 + pen.X
				y2 = y2 + pen.Y
				x = x + pen.X
				y = y + pen.Y
			end
			shape["path"] = shape["path"] .. " | CurveTo " .. x .. ", " .. y .. ", " .. x1 .. ", " .. y1 .. ", " .. x2 .. ", " .. y2 
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
		--else
		--	print("Invalid bezier curve ", parameters[i], parameters[i+1], parameters[i+2], parameters[i+3], parameters[i+4], parameters[i+5])
		--end
	end
end