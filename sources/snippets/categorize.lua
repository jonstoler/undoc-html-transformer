local sorted = {{path = "", has = {}, type = "index", name = "index", depth = 0}}
local sb = {}
local function categorize(t)
	local path = {}
	local bc = {{name = "index", url = ""}}
	local package = {}
	local class = nil
	local history = {sorted[1]}

	local order = {
		index = 1,
		package = 1,
		class = 2,
		["function"] = 3,
		constructor = 3,
		variable = 4,
	}

	local function insert(key, obj)
		if key == "packages" or key == "classes" then
			table.insert(sb, {name = obj.name, url = obj.url, header = (key == "packages")})
			for k, v in pairs(history) do
				v.has[key] = v.has[key] or {}
				table.insert(v.has[key], obj)
			end
		else
			local v = history[1]
			v.has[key] = v.has[key] or {}
			table.insert(v.has[key], obj)
		end
	end

	local function copy(tbl)
		local c = {}
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				c[k] = copy(v)
			else
				c[k] = v
			end
		end
		return c
	end

	local function sort(tbl)
		for k, v in pairs(tbl) do
			if v.type == "package" then
				class = nil
				table.insert(path, v.name)
				table.insert(package, v.name)
				local url = table.concat(path, "/")
				table.insert(bc, {name = v.name, url = url .. "/"})
				insert("packages", {name = table.concat(path, "."), description = v.description, url = url})
				table.insert(sorted, {path = url, has = {}, type = v.type, name = table.concat(package, "."), description = v.description, depth = #path, breadcrumbs = copy(bc), title = table.concat(package, ".")})
				table.insert(history, 1, sorted[#sorted])
				if v.children then sort(v.children) end
				table.remove(history, 1)
				table.remove(bc)
				table.remove(package)
				table.remove(path)
			elseif v.type == "class" then
				class = v.name
				table.insert(path, "classes")
				table.insert(path, v.name)
				local url = table.concat(path, "/")
				table.insert(bc, {name = v.name, url = url .. "/"})
				insert("classes", {name = v.name, description = v.description, url = url, superclass = v.superclass})
				table.insert(sorted, {path = url, has = {}, type = v.type, name = v.name, depth = #path, description = v.description, breadcrumbs = copy(bc), title = table.concat(package, ".") .. "." .. v.name, superclass = v.superclass})
				table.insert(history, 1, sorted[#sorted])
				if v.children then sort(v.children) end
				table.remove(history, 1)
				table.remove(bc)
				table.remove(path)
				table.remove(path)
			elseif v.type == "function" or v.type == "constructor" then
				table.insert(path, "functions")
				table.insert(path, v.name)
				local url = table.concat(path, "/")
				table.insert(bc, {name = v.name, url = url .. "/"})
				insert("functions", {name = (v.type == "function" and v.name or class), description = v.description, url = url, arguments = v.arguments, returns = v.returns, scope = v.scope})
				table.insert(sorted, {path = url, has = {}, type = v.type, name = v.name, depth = #path, description = v.description, breadcrumbs = copy(bc), arguments = v.arguments, returns = v.returns, scope = v.scope, title = (class and (class .. ".") or (table.concat(package, ".") .. " - ")) .. v.name .. "()"})
				table.insert(history, 1, sorted[#sorted])
				if v.children then sort(v.children) end
				table.remove(history, 1)
				table.remove(bc)
				table.remove(path)
				table.remove(path)
			elseif v.type == "variable" then
				table.insert(path, "variables")
				table.insert(path, v.name)
				local url = table.concat(path, "/")
				table.insert(bc, {name = v.name, url = url .. "/"})
				insert("variables", {name = v.name, description = v.description, url = url, class = v.class, default = v.default, type = v.type, scope = v.scope})
				table.insert(sorted, {path = url, has = {}, type = v.type, name = v.name, depth = #path, description = v.description, breadcrumbs = copy(bc), class = v.class, default = v.default, scope = v.scope, title = (class and (class .. ".") or (table.concat(package, ".") .. " - ")) .. v.name})
				table.insert(history, 1, sorted[#sorted])
				if v.children then sort(v.children) end
				table.remove(history, 1)
				table.remove(bc)
				table.remove(path)
				table.remove(path)
			elseif v.type == "code" then
				insert("code", {name = v.name, language = v.language, code = v.code})
			end
		end
	end

	sort(t)
end
