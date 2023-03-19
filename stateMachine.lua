local transition = require "transition"

---@class stateMachine
stateMachine = {}

---state that is used as Start node.
stateMachine.STARTSTATE = setmetatable({type = "stateMachine.Start"}, {__tostring = function() return "stateMachine.Start" end})

---state that is used as End node.
---Once stateMachine reaches this state, it's over.
stateMachine.ENDSTATE = setmetatable({type = "stateMachine.End"}, {__tostring = function() return "stateMachine.End" end})

---Create new stateMachine instance
function stateMachine.New()
  local obj = { currentState = stateMachine.STARTSTATE
              , states = {}
              , transitions = {}
              , parameters = {}
            }

  local function toStr(self)
    return string.format("(stateMachine :currentState %s\n\t:states %s)",
                        self.currentState, self.states)
  end

  return setmetatable(obj, {__index=stateMachine, __tostring=toStr})
end

function stateMachine:AddTransition(transition)
  table.insert(self.transitions, transition)
end

---@param state any
function stateMachine:AddStartTransition(state)
  table.insert(self.transitions, transition.New(self.currentState, state, function(_) return true end))
end

function stateMachine:AddEndTransition(state, condition)
   table.insert(self.transitions, transition.New(state, self.ENDSTATE, condition))
end

---@param state any
function stateMachine:AddState(state)
  table.insert(self.states, state)
end

---Add new parameter. It's type is inherited from "initial" value
---
---Available types are: primitives, trigger
---Trigger is an object that contains two fields, "type: trigger" and "status: "
---It should be false after executing "Update" function
---
---@param name string
---@param initial any initial value for the parameter.
function stateMachine:AddParameter(name, initial)
  self.parameters[name] = initial
end

---Update state and change animation if required
---@param name string
---@param value any (But should be valid for 'name' parameter
---@return boolean true if update success, false otherwise
function stateMachine:Update(name, value)
   ---postHook contains all hook functions required to run at end of Update sequence
   local postHook = function() end

  --Type checks {{{
  if self.parameters[name] == nil then
    return false
  end

  -- Triggers should be processed specially.
  if type(self.parameters[name]) == "table" and self.parameters[name].type == "trigger" then
     self.parameters[name].state = true
     postHook = function() self.parameters[name].state = false end
  else
     -- Basically, value should be the same type as parameter value.
     -- But object parameter sometimes require other data type(e.g. trigger).
     if type(self.parameters[name]) ~= type(value) then
	return false
     end
     self.parameters[name] = value
  end
  --}}}


  self:_CheckTransitions()

  -- Deactivate each triggers
  postHook()
end

---Iterate each transitions and find 
function stateMachine:_CheckTransitions()
  for _, t in pairs(self.transitions) do
    if t:IsFrom(self.currentState) and t:Check(self.parameters) then
      self.currentState = t.to
    end
  end
end

---Start executing current state
function stateMachine:Run()
  self:_CheckTransitions()
end

return stateMachine
