local stateMachine = require "stateMachine"
local dummyPlayer = require "dummyPlayer"
local asm = require "asm"

-- Creating statemachine {{{
mySM = stateMachine.New()

local idle = "idle"
local popup = "popup"
local transmitting = "transmitting"
local shrink = "shrink"
mySM:AddState(idle)
mySM:AddState(popup)
mySM:AddState(transmitting)
mySM:AddState(shrink)

mySM:AddParameter("transmitting", false)
mySM:AddParameter("quit", false)

mySM:AddStartTransition(idle)
mySM:AddTransition(transition.New(idle, popup, function(params) return params.transmitting end))
mySM:AddTransition(transition.New(popup, transmitting, function(params) return params.asm_animationEnd.state end))
mySM:AddTransition(transition.New(transmitting, shrink, function(params) return not params.transmitting end))
mySM:AddTransition(transition.New(shrink, idle, function(params) return params.asm_animationEnd.state end))
mySM:AddEndTransition(idle, function(params) return params.quit end)
-- }}}


myAsm = asm.ConvertFromStateMachine(mySM, dummyPlayer.New())
print(mySM.currentState)
local animCo = myAsm:Run()

local eventCo = coroutine.create(function()
      for j=1, 3 do coroutine.yield() end
      myAsm:Update("transmitting", true)
      for j=1, 10 do coroutine.yield() end
      myAsm:Update("transmitting", false)
      for j=1, 3 do coroutine.yield() end
      print("[eventCo] finished")
      myAsm:Update("quit", true)
end)


for i = 1, 30 do
   coroutine.resume(animCo)
   coroutine.resume(eventCo)
   print(myAsm.currentState)
end 
