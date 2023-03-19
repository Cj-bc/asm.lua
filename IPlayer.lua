---@class IPlayer
IPlayer = {}

---Play given clip. If it's playing other clip, it should be stopped
---@param clip string
function IPlayer:Play(clip)
end

---@return boolean
function IPlayer:IsPlaying()
end

---Stop playing current clip
function IPlayer:Stop()
end

return IPlayer
