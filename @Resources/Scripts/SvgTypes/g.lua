--[[

This handles the <g></g> tag, which styles it's children. 

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

--]]

return function (shapes, attributes, children, groupModifiers, value) -- group 
	debugPrint("group")
	if children ~= nil then
		local mods = getModifiers(attributes)
		groupModifiers = mergeModifiers(groupModifiers, mods)
		local class = attributes["class"]
		if shapeStyles[class] ~= nil then
			groupModifiers = mergeModifiers(groupModifiers, shapeStyles[class])
		end
		for i, j in pairs(children) do
			shapes = getShape(j, shapes, groupModifiers)
		end
	end
	return shapes
end