local stateMachine = require "stateMachine"

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
mySM:AddParameter("animationEnd",{type = "trigger", status = false})

mySM:AddStartTransition(idle)
mySM:AddTransition(transition.New(idle, popup, function(params) return params.transmitting end))
mySM:AddTransition(transition.New(popup, transmitting, function(params) return params.animationEnd.state end))
mySM:AddTransition(transition.New(transmitting, shrink, function(params) return not params.transmitting end))
mySM:AddTransition(transition.New(shrink, idle, function(params) return params.animationEnd.state end))
-- }}}

-- execution
mySM:Run()
print(mySM.currentState)
mySM:Update("transmitting", true)
print(mySM.currentState)
mySM:Update("animationEnd", {}) -- any value can be supplied
print(mySM.currentState)
mySM:Update("transmitting", false)
print(mySM.currentState)
mySM:Update("animationEnd", {}) -- any value can be supplied
print(mySM.currentState)
