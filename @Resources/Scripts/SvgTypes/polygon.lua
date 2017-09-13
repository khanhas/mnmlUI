--[[

This converts the <polygon></polygon> tag in .svg to a shape that rainmeter can use

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

--]]

return function (shapes, attributes, children, groupModifiers, value)

	local shape = newShape(groupModifiers, attributes)
	local class = attributes["class"]
	shape["modifiers"] = mergeModifiers(shape["modifiers"], shapeStyles[class])
	debugPrint("polygon")
	local parameters = attributes["points"]
	parameters = trim(parameters:gsub("%s+", " "))

	parameters = parseSvgNumbers(parameters)

	local path = ""
	local first = true
	for i=1, #parameters, 2 do
		local x = tonumber(parameters[i])
		local y = tonumber(parameters[i+1])
		if first then
			path = path .. x .. ", " .. y
			first = false
		else
			path = path .. " | LineTo " .. x .. ", " .. y
		end
	end
	path = path .. " | ClosePath 1"

	shape["shape"] = "Path Path"..nextPath
	shape["path"] = path
	nextPath = nextPath + 1

	local class = attributes["class"]
	if shapeStyles[class] ~= nil then
		shape["modifiers"] = mergeModifiers(shape["modifiers"], shapeStyles[class])
	end

	shapes[#shapes+1] = shape
	return shapes
end