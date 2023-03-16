local IPlayer = require "IPlayer"
local animationState = require "animationState"

dummyPlayer = {}

function dummyPlayer.New()
  return setmetatable({}, {__index=dummyPlayer})
end

function dummyPlayer:Play(state)
  if animationState.Validate(state) then
    print(string.format("start playing: %s", tostring(state.clip)))
  end
end

function dummyPlayer:Stop()
  print("Stopped!")
end

return dummyPlayer
