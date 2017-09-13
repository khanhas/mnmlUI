--[[

This handles the <svg></svg> tag, which declares that the following is a svg shape

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

]]

return function (shapes, attributes, children, groupModifiers, value)
	debugPrint("svg", children, attributes)
	if children == nil then
		print(ErrorEmptySVG)
		return nil
	end
	if attributes == nil then
		print(CorruptSVG)
		return nil
	end

	if attributes["viewBox"] ~= nil then
		local view = split(attributes["viewBox"], " ")
		local x = view[1]
		local y = view[2]
		local width = view[3]
		local height = view[4]
		shapes["X"] = tostring(-tonumber(x))
		shapes["Y"] = tostring(-tonumber(y))
		shapes["width"] = width
		shapes["height"] = height
	end

	for i, j in pairs(children) do
		shapes = getShape(j, shapes, groupModifiers)
	end
	return shapes
end