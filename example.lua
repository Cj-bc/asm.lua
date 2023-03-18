local asm = require "asm"
local dummyPlayer = require "dummyPlayer"

stateMachine = asm.New()

local fooBar = "fooBar"
stateMachine:AddState(fooBar)
local popup = "popup.clip"
stateMachine:AddState(popup)

stateMachine:AddParameter("stop", false)

stateMachine:AddStartTransition(fooBar)
stateMachine:AddTransition(transition.New(fooBar, popup, function(params) return params.stop == true end))
stateMachine:Run()
stateMachine:Update("stop", true)
