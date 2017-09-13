--[[

the close path segment closes the path. 

parameters - a table of numbers that is the numbers trailing the segment character (e.g "M 200, 300")
pen - the current pen location (table: { X= xPos, Y = yPos} ) 
shape - the current shape 
relative - is this relative to the last pen location

--]]

return function (parameters, pen, shape, relative)
	shape["path"] = shape["path"] .. " | ClosePath 1"
	lastControlX = x2
	lastControlY = y2
	lastQuadraticX = nil
	lastQuadraticY = nil
end