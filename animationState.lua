---@class AnimationState
AnimationState = {}

---Create New AnimationState for given clipPath
---@param clipPath string
function AnimationState.New(clipPath)
  local animationState = { clip = clipPath
                       }

  function toStr(self)
    return string.format("(AnimationState :clip %q)"
                        , self.clip)
  end

  return setmetatable(animationState, {__index=AnimationState, __tostring=toStr})
end

-- | Validate given target is valid animationState or not
function AnimationState.Validate(target)
  return getmetatable(target) == AnimationState
end


return AnimationState
