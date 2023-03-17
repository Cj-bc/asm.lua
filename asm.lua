local state = require "animationState"
local transition = require "transition"

asm = {}

---@param player IPlayer
function asm.New(player)
  local startState = state.New("Start")
  local obj = { currentState = startState
              , player = player
              , states = {}
              , transitions = {}
              , parameters = {}
            }

  local function toStr(self)
    return string.format("(asm :currentState %s\n\t:player %s\n\t:states %s)",
                        self.currentState, self.player, self.states)
  end

  return setmetatable(obj, {__index=asm, __tostring=toStr})
end

function asm:AddTransition(transition)
  table.insert(self.transitions, transition)
end

---@param state animationState
function asm:AddStartTransition(state)
  table.insert(self.transitions, transition.New(self.currentState, state, function(_) return true end))
end

---@param state animationState
function asm:AddState(state)
  table.insert(self.states, state)
end

---Add new parameter. It's type is inherited from "initial" value
---@param name string
---@param initial any
function asm:AddParameter(name, initial)
  self.parameters[name] = initial
end

---Update state and change animation if required
function asm:Update(name, value)
  if self.parameters[name] == nil then
    return false
  end

  if type(self.parameters[name]) ~= type(value) then
    return false
  end

  self.parameters[name] = value

  self:_CheckTransitions()
end

function asm:_CheckTransitions()
  for _, t in pairs(self.transitions) do
    if t:IsFrom(self.currentState) and t:Check(self.parameters) then
      self.player:Stop()
      self.currentState = t.to
      (self.player):Play(self.currentState)
    end
  end
end

---Start executing current state
function asm:Run()
  self:_CheckTransitions()
end

---Stop currently running state
function asm:Stop()
  self.player:Stop()
end

return asm
