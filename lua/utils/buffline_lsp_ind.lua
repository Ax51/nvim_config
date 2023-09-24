return function(count, level)
	local icon = level:match("error") and "🔻 " or "🔸 "
	-- local icon = level:match("error") and " " or " " -- default icon
	return " " .. icon .. count
end
