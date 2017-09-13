--[[

This converts the <path></path> tag in .svg to a shape that rainmeter can use

Note: This is a pretty advanced tag, and i've therefore made the segments into modules inside #@#Scripts/PathTypes

shapes - All shapes generated so far, do "shapes[#shapes + 1] = shape" to add a new shape
attributes - This is the attributes for the tag (e.g <svg class="Test"></svg>, class is an attribute to the svg tag )
children - All the tags inside the current tag
groupModifiers - These are modifiers that is applied through inheritence by the <g></g> tag
value - The actual value of the tag (e.g the content inside that tags that are not other tags.)

--]]

-- Table where the functions of all the path types are stored
pathSegments = {}

--These are used for the C, S, Q and T segments, used to calculate the S and T control points
lastControlX = nil
lastControlY = nil
lastQuadraticX = nil
lastQuadraticY = nil

local pathSegmentDir = SKIN:ReplaceVariables("#@#Scripts\\PathTypes\\")

local function LoadPathSegments(files)
	for id, file in pairs(files) do
		fileName = split(file, ".")[1]
		pathSegments[fileName] = dofile(pathSegmentDir .. file)
	end
	print("Path segments loaded")
end

LoadFiles(pathSegmentDir, LoadPathSegments)

function parsePath(input)
    local out = {};

    for instr, vals in input:gmatch("([a-df-zA-DF-Z])([^a-df-zA-DF-Z]*)") do
        local line = { instr };
        local carry = nil
        for v in vals:gmatch("([+-]?[%deE.]+)") do
            if v:match("[eE]") then
            	carry = v
            else
            	if carry then
            		line[#line+1] = carry .. v;
            		carry = nil
            	else
            		line[#line+1] = v;
            	end
        	end

        end
        out[#out+1] = line;
    end
    return out;
end


return function (shapes, attributes, children, groupModifiers, value)
	local shape = newShape(groupModifiers, attributes)
	local class = attributes["class"]
	if shapeStyles[class] ~= nil then
		shape["modifiers"] = mergeModifiers(shapeStyles[class], shape["modifiers"])
	end
	shape["shape"] = "Path Path" .. nextPath
	nextPath = nextPath + 1
	--local path = trim(attributes["d"]:gsub("%s+", " "))
	local pen = {X = 0, Y = 0}

	local combine = ""
	local fistCombine = true
	local shapeCount = 0
	local iterations = 0
	
	local special = shape["modifiers"]["Special"]
	
	local segments = parsePath(attributes["d"])
	for i=1, #segments do
		local parameters = segments[i]
		local char = parameters[1]
		table.remove(parameters, 1)

		if pathSegments[char:upper()] ~= nil then
			local relative = char:lower() == char
			local nextShape = pathSegments[char:upper()](parameters, pen, shape, relative)

			if nextShape ~= nil and nextShape ~= shape then
				if fistCombine then
					combine = "Combine Shape" .. (#shapes + 1)
					fistCombine = false
				else
					combine = combine .. " | XOR Shape" .. (#shapes + 1)
					shape["modifiers"] = {}
					shape["modifiers"]["Special"] = special
				end
				shapes[#shapes+1] = shape
				shape = nextShape
				shapeCount = shapeCount + 1
			end
		else
			print("Path segment by type " .. char:upper() .. " does not exist!")
		end
		iterations = iterations + 1
	end

	if shape["shape"] ~= nil and trim(shape["shape"]) ~= "" and iterations > 1 then
		if fistCombine then
			combine = "Combine Shape" .. (#shapes + 1)
			fistCombine = false
		else
			combine = combine .. " | XOR Shape" .. (#shapes + 1)
			shape["modifiers"] = {}
			shape["modifiers"]["Special"] = special
		end
		shapes[#shapes+1] = shape
		shape = nextShape
		shapeCount = shapeCount + 1
	else
		nextPath = nextPath - 1
	end

	if combine ~= "" and shapeCount > 1 then
		local combinedShape = {modifiers = {}}
		combinedShape["shape"] = combine
		combinedShape["modifiers"]["Special"] = special
		combinedShape["combined"] = true
		shapes[#shapes+1] = combinedShape
	end

	return shapes
end
