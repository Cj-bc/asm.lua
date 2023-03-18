local asm = require "asm"

stateMachine = asm.New()

local idle = "idle"
local popup = "popup"
local transmitting = "transmitting"
local shrink = "shrink"
stateMachine:AddState(idle)
stateMachine:AddState(popup)
stateMachine:AddState(transmitting)
stateMachine:AddState(shrink)

stateMachine:AddParameter("transmitting", false)
stateMachine:AddParameter("animationEnd",{type = "trigger", status = false})

stateMachine:AddStartTransition(idle)
stateMachine:AddTransition(transition.New(idle, popup, function(params) return params.transmitting end))
stateMachine:AddTransition(transition.New(popup, transmitting, function(params) return params.animationEnd.state end))
stateMachine:AddTransition(transition.New(transmitting, shrink, function(params) return not params.transmitting end))
stateMachine:AddTransition(transition.New(shrink, idle, function(params) return params.animationEnd.state end))
-- }}}

-- execution
stateMachine:Run()
print(stateMachine.currentState)
stateMachine:Update("transmitting", true)
print(stateMachine.currentState)
stateMachine:Update("animationEnd", {}) -- any value can be supplied
print(stateMachine.currentState)
stateMachine:Update("transmitting", false)
print(stateMachine.currentState)
stateMachine:Update("animationEnd", {}) -- any value can be supplied
print(stateMachine.currentState)
