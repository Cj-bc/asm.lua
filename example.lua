local asm = require "asm"
local animationState = require "animationState"
local dummyPlayer = require "dummyPlayer"

stateMachine = asm.New()

local fooBar = animationState.New("")
stateMachine:AddState(fooBar)
local popup = animationState.New("popup.clip")
stateMachine:AddState(popup)

stateMachine:AddParameter("stop", false)

stateMachine:AddStartTransition(fooBar)
stateMachine:AddTransition(transition.New(fooBar, popup, function(params) return params.stop == true end))
stateMachine:Run()
stateMachine:Update("stop", true)
