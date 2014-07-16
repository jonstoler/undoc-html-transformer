-- hacky solution to detect directory separator, used for file commands
local _os = (package.config:sub(1, 1) == "/") and "UNIX" or "DOS"

local fs = {
	mkdir = function(dir)
		if _os == "UNIX" then
			os.execute("mkdir -p " .. dir .. "> /dev/null")
		elseif _os == "DOS" then
			dir = dir:gsub("/", "\\")
			os.execute("md " .. dir)
		end
	end,

	cat = function(file)
		if _os == "DOS" then file = file:gsub("/", "\\") end
		local f, err = io.open(file, "r")
		if not f then
			print("ERROR: could not read file " .. file .. " (" .. err .. ")")
			os.exit(-1)
		end
		local c = f:read("*all")
		f:close()
		return c
	end,

	echo = function(file, content)
		if _os == "DOS" then file = file:gsub("/", "\\") end
		local f, err = io.open(file, "w")
		if not f then
			print("ERROR: could not write file " .. file .. " (" .. err .. ")")
			os.exit(-1)
		end
		f:write(content)
		f:close()
	end,

	append = function(file, content)
		if _os == "DOS" then file = file:gsub("/", "\\") end
		local f, err = io.open(file, "a")
		if not f then
			print("ERROR: could not write file " .. file .. " (" .. err .. ")")
			os.exit(-1)
		end
		f:write(content)
		f:close()
	end
}

