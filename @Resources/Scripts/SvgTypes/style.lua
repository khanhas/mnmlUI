--[[

handles the <style></style> tag in the .svg, and saves them to the shapeStyles table to be fetched later.

Note: only classes are handled for now, i assume that ids will probably appear, but i have yet to implement that

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

--]]

return function (shapes, attributes, children, groupModifiers, value)
	local firstSplit = split(value, "}")
	for i, stylePart in pairs(firstSplit) do
		local idContentPair = split(stylePart, "{")
		local ids = split(idContentPair[1], ",")
		for j, id in pairs(ids) do
			local id = trim(id):sub(2)
			local content = idContentPair[2]
			local att = {}
			att["style"] = content
			local modifiers = getModifiers(att)
			shapeStyles[id] = mergeModifiers(modifiers, shapeStyles[id])
		end
	end
	return shapes
end