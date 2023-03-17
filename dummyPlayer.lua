local IPlayer = require "IPlayer"
local animationState = require "animationState"

dummyPlayer = {}

function dummyPlayer.New()
  return setmetatable({}, {__index=dummyPlayer})
end

function dummyPlayer:Play(state)
  print(string.format("start playing: %s", tostring(state.clip)))
end

function dummyPlayer:Stop()
  print("Stopped!")
end

return dummyPlayer
