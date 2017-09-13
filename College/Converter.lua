
svgTypes = {}

debugPrint = function(k)  end
nextPath = 2;
shapeStyles = {}


local ErrorEmptySVG = "Error: Parsing empty Svg file"
local CorruptSVG = "Error: The svg file is corrupt"
local GetModifiersError = "Error: Invalid attributes table given to get modifiers, returning nil"

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

function getShape(xmlTable, shapes, groupModifiers)
	local svgTypeName = xmlTable["Name"]
	local children = xmlTable["ChildNodes"]
	if svgTypes[svgTypeName] ~= nil then
		shapes = svgTypes[svgTypeName](shapes, xmlTable["Attributes"], children, deepcopy(groupModifiers), xmlTable["Value"])
	end
	return shapes
end

function xmlToShape(svgFile)

	local xml = XmlParser:ParseXmlFile(svgFile)
	if xml["Name"] ~= "svg" then
		print("Invalid svg file: ", svgFile)
		return nil
	end
	nextPath = 1
	style = {}
	endShapes = getShape(xml, {}, {})
	return endShapes
end


function Initialize()
	ColorKeywordsPath = SKIN:ReplaceVariables("#@#Scripts/ColorKeywords.lua")

	XmlParser = dofile(SKIN:ReplaceVariables("#@#Scripts/XmlParser.lua"))
	dofile(SKIN:ReplaceVariables("#@#Scripts/FileLoader.lua")) -- FileLoader
	dofile(SKIN:ReplaceVariables("#@#Scripts/HelperFunctions.lua")) -- HelperFunctions
	dofile(SKIN:ReplaceVariables("#@#Scripts/ModifierHandler.lua")) -- ModifierHandler

	local dir = SKIN:ReplaceVariables("#@#Scripts\\SvgTypes\\")

	local SvgLoad = function(files)
		for id, file in pairs(files) do
			fileName = split(file, ".")[1]
			svgTypes[fileName] = dofile(dir .. file)
		end
	end

	LoadFiles(dir, SvgLoad)
	countshape = 0
	countpath = 0
end

function ConvertFile()
	local path = SKIN:MakePathAbsolute(SELF:GetOption("SVGfile"))
	local shapes = xmlToShape(path)

	local paths = {}

	local meterOptions = ""

	countshape = 0
	local union = {}

	for i,shape in pairs(shapes) do
		if shape["shape"] ~= nil then
			if shape["modifiers"]["Special"]["Display"] then
				local shapeName = "Shape"

				if i ~= 1 then shapeName = shapeName .. i end
				table.insert(union,'|Union '..shapeName)
				meterOptions = meterOptions .. "[!SetOption Shape " .. shapeName .. " \"" .. shape["shape"]

				local sepNum = 1

				for separator in string.gmatch(shape["shape"],"|") do sepNum = sepNum+1 end
				
				if sepNum ~= 1 then
					for j=(i-1),(i-sepNum),-1 do
						union[j] = ""
					end
				end

				for modifierName, modifierValue in pairs(shape["modifiers"]) do
					if modifierName ~= "Special" then 
						meterOptions = meterOptions .. " | " .. modifierName .. " " .. modifierValue
					end
				end

				if shape["modifiers"]["StrokeWidth"] == nil and shape["combined"] == nil then
					meterOptions = meterOptions .. " | StrokeWidth 0"
				end

				meterOptions = meterOptions .. "\"]"
				
				if shape["path"] ~= nil then
					paths[#paths+1] = shape["path"]
				end
			end
			countshape = countshape + 1

		end
	end

	countpath = 0
	for i, path in pairs(paths) do
		meterOptions = meterOptions .. "[!SetOption Shape Path" .. i .. " \"" .. path .. "\"]"
		countpath = countpath + 1
	end
	meterOptions = meterOptions .. "[!SetOption Shape Shape"..(countshape+1).." \"Rectangle 0,0,0,0|StrokeWidth 0\"]"
	meterOptions = meterOptions .. "[!SetOption Shape Shape"..(countshape+2).." \"Combine Shape"..(countshape+1)..table.concat(union).."\"]"
	meterOptions = meterOptions .. "[!SetOption Shape Shape"..(countshape+3).." \"Ellipse (300*#scale#),(200*#scale#),(60*#scale#) | StrokeWidth 0 | Fill Color #Color#\"]"
	meterOptions = meterOptions .. "[!SetOption Shape Shape"..(countshape+4).." \"Combine Shape"..(countshape+3).."|XOR Shape"..(countshape+2).."|Intersect Shape"..(countshape+2).."\"]"
	SKIN:Bang(meterOptions)
end

function ClearAllShapePath()
	SKIN:Bang('[!SetOption Shape Shape \"\"]')
	for i=2,(countshape+4) do SKIN:Bang('[!SetOption Shape Shape'..i..' \"\"]') end
	for i=1,countpath do SKIN:Bang('[!SetOption Shape Path'..i..' \"\"]') end
end

function ConvertFile2()
	local path = SKIN:MakePathAbsolute(SELF:GetOption("SVGfile2"))
	local shapes = xmlToShape(path)

	local paths = {}

	local meterOptions = ""

	countshape2 = 0
	local union = {}

	for i,shape in pairs(shapes) do
		if shape["shape"] ~= nil then
			if shape["modifiers"]["Special"]["Display"] then
				local shapeName = "Shape"

				if i ~= 1 then shapeName = shapeName .. i end
				table.insert(union,'|Union '..shapeName)
				meterOptions = meterOptions .. "[!SetOption Shape2 " .. shapeName .. " \"" .. shape["shape"]

				local sepNum = 1

				for separator in string.gmatch(shape["shape"],"|") do sepNum = sepNum+1 end
				
				if sepNum ~= 1 then
					for j=(i-1),(i-sepNum),-1 do
						union[j] = ""
					end
				end

				for modifierName, modifierValue in pairs(shape["modifiers"]) do
					if modifierName ~= "Special" then 
						meterOptions = meterOptions .. " | " .. modifierName .. " " .. modifierValue
					end
				end

				if shape["modifiers"]["StrokeWidth"] == nil and shape["combined"] == nil then
					meterOptions = meterOptions .. " | StrokeWidth 0"
				end

				meterOptions = meterOptions .. "\"]"
				
				if shape["path"] ~= nil then
					paths[#paths+1] = shape["path"]
				end
			end
			countshape2 = countshape2 + 1

		end
	end

	countpath2 = 0
	for i, path in pairs(paths) do
		meterOptions = meterOptions .. "[!SetOption Shape2 Path" .. i .. " \"" .. path .. "\"]"
		countpath2 = countpath2 + 1
	end
	meterOptions = meterOptions .. "[!SetOption Shape2 Shape"..(countshape2+1).." \"Rectangle 0,0,0,0|StrokeWidth 0 \"]"
	meterOptions = meterOptions .. "[!SetOption Shape2 Shape"..(countshape2+2).." \"Combine Shape"..(countshape2+1)..table.concat(union).."\"]"
	meterOptions = meterOptions .. "[!SetOption Shape2 Shape"..(countshape2+3).." \"Ellipse (300*#scale#),(200*#scale#),(53*#scale#) | StrokeWidth 0 | Fill Color #Color2#\"]"
	meterOptions = meterOptions .. "[!SetOption Shape2 Shape"..(countshape2+4).." \"Combine Shape"..(countshape2+3).."|XOR Shape"..(countshape2+2).."\"]"
	SKIN:Bang(meterOptions)
end

function ClearAllShapePath2()
	SKIN:Bang('[!SetOption Shape2 Shape \"\"]')
	for i=2,(countshape2+4) do SKIN:Bang('[!SetOption Shape2 Shape'..i..' \"\"]') end
	for i=1,countpath2 do SKIN:Bang('[!SetOption Shape2 Path'..i..' \"\"]') end
end