--[[

the Arc segment is one or multiple arcs

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	for i=1, #parameters, 7 do
		local rx = tonumber(parameters[i])
		local ry = tonumber(parameters[i+1])
		local rotationAngle  = tonumber(parameters[i+2])
		local arcSize  = tonumber(parameters[i+3])
		local sweep  = tonumber(parameters[i+4])
		sweep = 1 - sweep
		local x  = tonumber(parameters[i+5])
		local y  = tonumber(parameters[i+6])
		if relative then
			x = x + pen.X
			y = y + pen.Y
		end

		shape["path"] = shape["path"] .. " | ArcTo " .. x .. ", " .. y .. ", " .. rx .. ", " .. ry .. ", " .. rotationAngle .. ", " .. sweep .. ", " .. arcSize

		lastControlX = nil
		lastControlY = nil
		lastQuadraticX = nil
		lastQuadraticY = nil
		pen.X = x
		pen.Y = y
	end
end