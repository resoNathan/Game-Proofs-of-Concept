--[[ todo: … ♪
♪ detect down press (good ending)
♪ detect held down press (bad ending)
♪ detect no action (no ending)
… detect left presses (begin of ending)
… detect xo patterns (true ending)
… create cutscene handler
	… write scripts
	… display text
	… compose music
	… draw(/commission) art
… add prophecy to menu
	… write prophecy with hints
--]]

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
		if btn(⬇️) then stage = 1; timer = 5 * 30 end
	--end of stage 0
	elseif stage == 1 then
		if btn(⬇️) then 
			timer = timer - 1
			if timer < 1 then cutscene(4) end-- bad ending
		else --i.e. if ️⬇️ is released
			cutscene(2) end -- good ending
	end--of stage 1
end--of _update()

function _draw() --placeholder
	cls(bgcolor)
	circfill(64,64,32,stage)
end--of _draw()

function cutscene(s)
	-- todo: write a handler for the ending screens
	stage = s
	bgcolor = 3
	-- note: using [[ and ]] lets you make multiline strings
	-- may be useful if writing this from scratch
end--of cutscene()
