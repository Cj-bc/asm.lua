local stateMachine = require "stateMachine"
local coroutine = require "coroutine"

---
---Special parameter "animationEnd" is appended
---
---@class asm
asm = setmetatable({}, {__index = stateMachine})

---Convert given stateMachine into Animation State Machine
---Note that given value will be *modified*
---
---@param sm stateMachine
---@param player IPlayer
function asm.ConvertFromStateMachine(sm, player)
   sm:AddParameter("asm_animationEnd", {type = "trigger", state = false})
   sm.player = player
   return setmetatable(sm, {__index = asm})
end

---Runs asm in coroutine
---@return coroutine
function asm:Run()
   stateMachine.Run(self)
   return coroutine.create(function()
	 local prevState = ""
	 while self.currentState ~= self.ENDSTATE do
	    if self.currentState ~= prevState then
	       self.player:Play(self.currentState)
	       prevState = self.currentState

	       -- TODO: Use other coroutine for this
	       -- so that we can interrupt while playing
	       -- animation
	       while self.player:IsPlaying() do
		  coroutine.yield()
	       end
	       self:Update("asm_animationEnd", {})
	    end
	 end
   end)
end

return asm
