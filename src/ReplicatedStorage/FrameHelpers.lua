local FrameHelpers = {}

-- Only show print in studio
function FrameHelpers:StudioPrint(...)
	if game.JobId == "" then
		print(...)
	end
end

-- Only show warn in studio
function FrameHelpers:StudioWarn(...)
	if game.JobId == "" then
		warn(...)
	end
end

-- Only show error in studio
function FrameHelpers:StudioError(...)
	if game.JobId == "" then
		error(...)
	end
end

return FrameHelpers
