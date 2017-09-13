
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
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function getShape(xmlTable, shapes, groupModifiers)
	local svgTypeName = xmlTable["Name"]
	local children = xmlTable["ChildNodes"]
	if svgTypes[svgTypeName] ~= nil then
		shapes = svgTypes[svgTypeName](shapes, xmlTable["Attributes"], children, deepcopy(groupModifiers), xmlTable["Value"]) -- Someone tell me why tf i need this nil here...
	end
	return shapes
end

--------------------------------------------------- The things above this will probably be moved to a separate file ;)

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
		print("Svg components initialized")
		
	end

	LoadFiles(dir, SvgLoad)
end

function ConvertFile()
	local path = SKIN:ReplaceVariables("#CurrentTextboxFile#")
	local shapes = xmlToShape(path)
	local xOffsett = shapes["X"]
	local yOffsett = shapes["Y"]

	local paths = {}

	local meterOptions = ""

	local X = 0
	local Y = 0

	if xOffsett ~= nil then
		X = X + tonumber(xOffsett)
	end

	if yOffsett ~= nil then
		Y = Y + tonumber(yOffsett)
	end
	countshape = 0
	for i,shape in pairs(shapes) do
		if shape["shape"] == nil then
			--print("ERROR IN SHAPE")
		else
			if shape["modifiers"]["Special"]["Display"] then
				local shapeName = "[!SetOption Shape Shape"
				if i ~= 1 then shapeName = shapeName .. i end
				meterOptions = meterOptions .. shapeName .. " \"" .. shape["shape"]

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
	SKIN:Bang(meterOptions)
	local meterOptions = meterOptions:gsub("\n", "#CRLF#")
	--SKIN:Bang("[!WriteKeyValue Variables CurrentTextboxFile \"\"]")
	--SKIN:Bang("[!SetOption CodeStr Text \"" .. meterOptions .. "\"][!UpdateMeter *][!Redraw]")
end

function ClearAllShapePath()
	SKIN:Bang('[!SetOption Shape Shape \"\"]')
	for i=2,countshape do SKIN:Bang('[!SetOption Shape Shape'..i..' \"\"]') end
	for i=1,countpath do SKIN:Bang('[!SetOption Shape Path'..i..' \"\"]') end
end
