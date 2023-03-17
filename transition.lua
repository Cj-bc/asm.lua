---@class transition
transition = {trigger = function(p) return false end}

---Create new transition
---@param from animationState
---@param to animationState
---@param triggerFunc fun(params: table): boolean
function transition.New(from, to, triggerFunc)
  local obj = { trigger = triggerFunc
              , from = from
              , to   = to
  }

  local function toStr(self)
    -- Adjust tab indentation
    local from = string.gsub(tostring(self.from), "\n\t", "\n\t\t")
    local to = string.gsub(tostring(self.to), "\n\t", "\n\t\t")
    local trigger = string.gsub(tostring(self.trigger), "\n\t", "\n\t\t")

    return string.format("(transition :from %s\n\t:to %s\n\t:trigger\n\t%s)"
                        , from, to, trigger)
  end

  obj.Check = function(self, params)
    return self.trigger(params)
  end

  return setmetatable(obj, {__index=transition, __tostring=toStr})
end

---Test if this transition is from given `state`
---@param state animationState
---@return boolean
function transition:IsFrom(state)
  return self.from == state
end

---true if this transition should be occurred based on given params
---@param params table
---@return boolean
function transition:Check(params)
  return self.trigger(params)
end


return transition
