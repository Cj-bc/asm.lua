local IPlayer = require "IPlayer"

dummyPlayer = {}

function dummyPlayer.New()
   return setmetatable({clipLength = 10, currentCount = 0}
      , {__index=dummyPlayer})
end

function dummyPlayer:Play(state)

  print(string.format("start playing: %s", tostring(state)))
end

function dummyPlayer:IsPlaying()
   if self.currentCount < self.clipLength then
      print("still playing...")
      self.currentCount = self.currentCount + 1
      return true
      -- coroutine.yield(false)
   end
   print("[dummyPlayer] play is stopped!")
   self.currentCount = 0
   return false
   -- coroutine.yield(true)
end

function dummyPlayer:Stop()
  print("Stopped!")
end

return dummyPlayer
