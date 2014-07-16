local function processArguments()
	local a = {}
	local option = false

	-- transformer (input/stdin) [options] output
	for k = 1, #arg do
		v = arg[k]
		if v:sub(1, 2) == "--" then
			if not option then
				option = v:sub(3)
			else
				a[option] = true
			end
		elseif k == #arg then
			a.output = v
		elseif k == 1 then
			a.input = v
		else
			if option then
				a[option] = v
				option = false
			else
				print('ERROR: "' .. v .. '" is not a valid option')
				os.exit(-1)
			end
		end
	end
	return a
end

local arguments = processArguments()
