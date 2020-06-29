ThisUUID = "VPR84296c0939f946089f45c97b9981afde"

--Playlist section
function probe()
  return string.match(vlc.peek(35), ThisUUID)
end

function parse()
        local ItemDescription = ThisUUID .. ";" .. vlc.path

        --Skip the first line. Checked in probe function
        vlc.readline()

        local LastPlayed = vlc.readline()
        local LastPlayedFound = false
        local PlayedItems = {}
        local NotPlayedItems = {}

        if not LastPlayed then return nil end

        local Line = vlc.readline()
        while Line
        do
                local Item = {}
                Item.path = Line
                Item.description = ItemDescription

                if LastPlayedFound then
                        table.insert(NotPlayedItems, Item)

                else
                        if LastPlayed == Line then LastPlayedFound = true end
                        table.insert(PlayedItems, Item)
                end

                Line = vlc.readline()
        end

        return JoinTables(NotPlayedItems, PlayedItems)
end

function JoinTables(Table1, Table2)
    for i = 1, #Table2 do
        Table1[#Table1 + 1] = Table2[i]
    end
    return Table1
end
------------------


function descriptor()
  	return {
    		title = "VPR",
    		capabilities = { "input-listener" }
  	}
end

function activate()
end

function deactivate()
end

function meta_changed()
end

function input_changed()
	local InputDescription = vlc.input.item():metas()["description"]

	--If this item is not in the playlist
	if (not string.match(InputDescription, ThisUUID)) then return end

    --The file which contains the playlist
	local PlaylistFile = GetFileAddressFromDescription(InputDescription)	

	UpdateLastPlayedItem(PlaylistFile, vlc.input.item():uri())
end

function GetFileAddressFromDescription(InputDescription)
	return Split(InputDescription, ";")[2]
end

function Split(Input, Delimiter)
    local Result = {};
    for Match in (Input .. Delimiter) : gmatch("(.-)" .. Delimiter) do
        table.insert(Result, Match);
    end
    return Result;
end

--From https://stackoverflow.com/a/9345320
function UpdateLastPlayedItem(PlaylistFile, NewLastItem)
	local hFile = io.open(PlaylistFile, "r") --Reading.
	local lines = {}
	local restOfFile
	local lineCt = 1

	for line in hFile:lines() do
		if(lineCt == 2) then 
    			lines[#lines + 1] = NewLastItem
    			restOfFile = hFile:read("*a")
    			break
  		else
    			lineCt = lineCt + 1
    			lines[#lines + 1] = line
  		end
	end

	hFile:close()

	hFile = io.open(PlaylistFile, "w") --write the file.
	for i, line in ipairs(lines) do
  		hFile:write(line, "\n")
	end
	hFile:write(restOfFile)
	hFile:close()
end
