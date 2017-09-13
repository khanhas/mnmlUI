
function getModifiers(attributes)  -- TODO: ADD MORE MODIFIERS
	if attributes == nil then
		return attributes
	end
	local modifiers = {}
	modifiers["Special"] = {}
	modifiers["Special"]["Display"] = true

	if attributes["style"] ~= nil then
		modifiers = dissectInkScape(modifiers, attributes["style"])
	else
		modifiers = dissectHTML(modifiers, attributes)
	end
	return modifiers
end

function mergeModifiers(groupModifiers, modifiers)
	if groupModifiers ~= nil and modifiers ~= nil then
		local merged = tableMerge(groupModifiers, modifiers)
		return merged
	elseif modifiers ~= nil then
		return modifiers
	elseif groupModifiers ~= nil then
		return groupModifiers
	end
	return {}
end

function newShape(groupModifiers, attributes)
	local modifiers = getModifiers(attributes)
	local shape = {}
	shape["modifiers"] = mergeModifiers(groupModifiers, modifiers)
	return shape
end

local colorKeywords = dofile(ColorKeywordsPath)

function getCssColor(color)
	if color == nil or type(color) ~= "string" then
		return nil
	end

	color = trim(color:lower())

	if colorKeywords[color] ~= nil then
		return colorKeywords[color]
	elseif color:sub(1, 3) == "rgb" then
		return color:gsub("rgb", ""):gsub("%(", ""):gsub("%)", "")
	else
		color = color:gsub("#", "")
		local r = tonumber(color:sub(1, 2), 16)
		local g = tonumber(color:sub(3, 4), 16)
		local b = tonumber(color:sub(5, 6), 16)

		return "" .. r .. ", " .. g .. ", " .. b
	end
	if color == "none" then return "0, 0, 0, 0" end
end

local 

function cssToShapeModifier(modifiers, modifierName, modifierValue)

	if modifierName == nil then return end
	if modifierValue == nil then 
		modifiers[modifierName] = nil 
	end

	if modifierName == "display" then 
		if modifierValue == "none" then 
			modifiers["Special"]["Display"] = false 
		end 
	end

	-- These are modifiers with direct bindings
	if modifierName == "fill" then  modifiers["fill color"] = getCssColor(modifierValue) end
	if modifierName == "stroke" then modifiers["stroke color"] = getCssColor(modifierValue) end
	if modifierName == "stroke-width" then modifiers["StrokeWidth"] = modifierValue:gsub("px", "") end

	-- These are attributes that can be done, but there is no direct modifier binding to them
	if modifierName == "stroke-opacity" then modifiers["Special"]["StrokeOpcaity"] = modifierValue end
	if modifierName == "fill-opacity" then modifiers["Special"]["FillOpcaity"] = modifierValue end


	-- TODO, ADD FILLMODE WHEN WE GET WINDING ;)

end

function dissectInkScape(modifiers, style)
	local styleParts = split(style, ";")
	for i,part in pairs(styleParts) do
		local stylePair = split(part, ":")
			local styleName = trim(stylePair[1])
			local styleValue = trim(stylePair[2])
			cssToShapeModifier(modifiers, trim(styleName), trim(styleValue))
			
	end
	return modifiers
end

function dissectHTML(modifiers, attributes)
	for i,j in pairs(attributes) do
		cssToShapeModifier(modifiers, trim(i), trim(j))
	end
	return modifiers 
end