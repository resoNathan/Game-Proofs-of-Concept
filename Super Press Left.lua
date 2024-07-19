function _init()
	-- variable declarations
	stage = 0
	maxtimer = 10 * 30 --seconds * frames
	timer = maxtimer
	bgcolor=2
end--of _init()

function _update()
	-- stage 0 is initial splash screen
	if stage == 0 then
		-- tick down timer if nothing is pressed...
		-- ...but reset it if something is pressed.
		timer = btn() < 1 and timer-1 or maxtimer
		
		-- check for "press nothing" ending
		if timer < 1 then cutscene(7) end
		
		-- todo: check for left presses for the "meet ☉" ending
		
		-- finally, check for a down press (like any sane developer would've done first)
		if btn(⬇️) then cutscene(1) end
	end--of stage 0
end--of _update()

function _draw() --placeholder
	cls(bgcolor)
	circfill(64,64,32,stage)
end--of _draw()

function cutscene(s)
	-- todo: write a handler for the ending screens
	stage = s
	bgcolor = 3
end--of cutscene()
