lure.core = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.core.init()
	
	-- CORE DEPENDENCIES
	require(lure.require_path .. "core//ns_lure_core_window")
	require(lure.require_path .. "core//ns_lure_core_layers")
	require(lure.require_path .. "core//ns_lure_core_alertBox")
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

lure.core.init()