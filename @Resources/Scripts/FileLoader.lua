local FileLoadQueue = {}
local IsLoading = false
FileLoadFinishedCallback = {}

function LoadFilesCallback()
	local measure = SKIN:GetMeasure("FileReader")
	local files = measure:GetStringValue()
	local allFiles = split(files, "\n")

	if #FileLoadQueue > 0 then
		local top = FileLoadQueue[1]
		top[2](allFiles)
		table.remove(FileLoadQueue, 1)
	end

	if #FileLoadQueue > 0 then
		local top = FileLoadQueue[1]
		local path = top[1]
		SKIN:Bang("[!SetOption FileReader StartInFolder \"".. path.. "\"][!UpdateMeasure FileReader][!CommandMeasure FileReader Run]")
	else
		IsLoading = false
		for _,j in pairs(FileLoadFinishedCallback) do j() end
	end
end

function LoadFiles(path, functionCallback)
	FileLoadQueue[#FileLoadQueue + 1] = {path, functionCallback}
	if not IsLoading then
		SKIN:Bang("[!SetOption FileReader StartInFolder \"".. path.. "\"][!UpdateMeasure FileReader][!CommandMeasure FileReader Run]")
		IsLoading = true
	end
end

function IsFilesLoading() return IsLoading end