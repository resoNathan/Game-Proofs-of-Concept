function _init()
	-- variable declarations
	stage = 0
	maxtimer = 30 * 30 --seconds * frames
	timer = maxtimer
end--of _init()

function _update()
	-- stage 0 is initial splash screen
	if stage = 0 then
		-- tick down timer if nothing is pressed...
		-- ...but reset it if something is pressed.
		timer = btn() < 1 and timer-1 or maxtimer
		
		-- check for "press nothing" ending
		if timer < 1 then cutscene(3) end
		
		-- todo: check for left presses for the "meet the eye E" ending
		
		-- finally, check for a down press (like any sane developer would've done first)
		if btn(D) then stage = 1 end
		-- make sure capital d D means down		
	end--of stage 0
end--of _update()

function _draw() --placeholder
	cls(1)
	circfill(64,64,32,stage)
end--of _draw()

function cutscene(s)
	-- todo: write a handler for the ending screens
	stage = 9
end--of cutscene()