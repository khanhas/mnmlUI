--[[

This converts the <circle></circle> tag in .svg to a shape that rainmeter can use

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

--]]

return function (shapes, attributes, children, groupModifiers, value)
	local shape = newShape(groupModifiers, attributes)
	local x = attributes["cx"]
	local y = attributes["cy"]
	local r = attributes["r"]
	shape["shape"] = "Ellipse " .. x .. ", " .. y .. ", " .. r
	local class = attributes["class"]
	if shapeStyles[class] ~= nil then
		shape["modifiers"] = mergeModifiers(shape["modifiers"], shapeStyles[class])
	end
	shapes[#shapes+1] = shape
	return shapes
end