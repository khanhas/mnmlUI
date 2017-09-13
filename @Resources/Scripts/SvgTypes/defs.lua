--[[

This handles the <defs></defs> tag that can be used in the .svg format
This is probably not fully implemented as i'm only sending the <style></style> tag that appears here into the parser again to be handled in style.lua

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

]]

return function (shapes, attributes, children, groupModifiers, value)
	--for i, j in pairs(children) do 
	--	shapes = getShape(j, shapes, groupModifiers)
	--end

	--TODO: this
	return shapes
end