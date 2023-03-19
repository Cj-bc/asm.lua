local vciPlayer = {}

---@param animation ExportAnimation vci animation
function vciPlayer.New(animation)
   local obj = {}
   obj.animation = animation
   return setmetatable(obj, {__index = vciPlayer})
end

function vciPlayer:Play(clip)
   if self.animation.HasClip(clip) then
      self.animation.PlayFromName(clip)
   end
end

function vciPlayer:IsPlaying()
   return self.animation.IsPlaying()
end

function vciPlayer:Stop()
   self.animation.Stop()
end

return vciPlayer
