--[[

	Removes spaces before and after the string

--]]
function trim(s)
	if s == nil then return nil end
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--[[

	Merges two tables, t2 takes priority and will overwrite values in t1

--]]

function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                t1[k] = tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

--[[

	Splits string at separator

--]]

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


--[[

	No regex, so manual number crunching.

	Takes a string and parses it into a table of numbers
	Warning, svg numbers can be very compressed and are therefore quite difficult to parse manually.
	e.g "4.2,3.1-2.3-.3,2-3.2" = {4.2, 3.1, -2.3, -0.3, 2, -3.2}

--]]

function parseSvgNumbers(parameters)
	local parsedNumbers = {}
	local pos = 0
	while pos <= #parameters do
		local prefix = parameters:find("-", pos)
		local nextNumberMax = false
		if prefix == nil then prefix = #parameters end

		local dot = parameters:find("%.", pos)
		if dot == nil then dot = #parameters end

		local number = parameters:find("[%d]+", pos)
		if number == nil then number = #parameters end
		local strNum = parameters:match("[%d]+", pos)
		if strNum ~= nil then
			local nextNumber = parameters:find("[%d]+", number + #strNum)
			if nextNumber == nil then nextNumber = #parameters nextNumberMax = true end
			local nextStrNum = parameters:match("[%d]+", number + #strNum)

			local separator = parameters:find("%s", pos)
			if separator == nil then separator = #parameters end
			if separator < number then
				separator = number + 1
				separator = parameters:find("%s", separator)
				if separator == nil then separator = #parameters end
			end
			local separator2 = parameters:find("%,", pos)
			if separator2 == nil then separator2 = #parameters end
			if separator2 < number then 
				separator2 = number + 1 
				separator2 = parameters:find("%,", separator2)
				if separator2 == nil then separator2 = #parameters end
			end
			if separator > separator2 then separator = separator2 end
			local nextPrefix = parameters:find("-", prefix+1)
			if nextPrefix == nil then nextPrefix = #parameters end

			local usePrefix = prefix < number
			local singleDecimal = dot < number
			local isDecimal = singleDecimal or ((prefix < number or prefix >= nextNumber) and nextNumber <= nextPrefix and nextNumber <= separator and not nextNumberMax) 
			local finalNum = 0
			local neg = 1
			if usePrefix then 
				neg = -1
			end
			if singleDecimal then
				finalNum = neg * tonumber("0." .. strNum)
				pos = number + #strNum
			elseif isDecimal then
				finalNum = neg * tonumber(strNum .. "." .. nextStrNum)
				pos = nextNumber + #nextStrNum
			else
				finalNum = neg * tonumber(strNum)
				pos = number + #strNum
			end
			parsedNumbers[#parsedNumbers + 1] = finalNum
		else
			pos = #parameters + 1
		end
	end

	return parsedNumbers
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == "boolean" then
    	local val = ""
    	if tprint then val = "true" else val = "false" end
    	print(formatting.. val)
    else
      print(formatting .. v)
    end
  end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end