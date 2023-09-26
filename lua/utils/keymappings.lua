local function remap(shortcut, command, mode, opts)
	local defmode = "n"
	local defopts = { silent = true }

	vim.keymap.set(mode or defmode, shortcut, command, opts or defopts)
end

local function nmap(shortcut, command, opts)
	remap(shortcut, command, "n", opts)
end

return {
	nmap,
	remap,
}
