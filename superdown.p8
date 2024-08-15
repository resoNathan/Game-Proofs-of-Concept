pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ⌂ required and helper funcs
function _init()
	--custom color palette
	--poke(0x5f2e, 1) --changes color consoleside (i think)
	--pal({128, 5, 6, 7} ,1)
	pal({128, 5, 6, 7,  5,6,7,6} ,1)
	
	-- variable declarations
	stage = 0
	maxtimer = 10 * 30 --seconds * frames
	timer = maxtimer
	scene = 0
end--of _init()

function _draw()
	if stage == 2 then draw_end()
	else draw_main() end
end

function _update()
	if stage < 2 then update_main() end
end

-------------------------------
				-- helper functions --
function circall(x,y,r,inner,outer)
	circfill(x,y,r,inner)
	circ(x,y,r,outer)
end

function hcenter(s)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  return 64-#s*2
end

function vcenter(s)
  -- screen center minus the
  -- string height in pixels,
  -- cut in half
  return 61
end

-->8
-- ⬇️ title screen


function draw_main()
	--bg
	cls(4)
	
	--plate
	--circfill(60, 71, 37, 3)
	circall(60, 71, 37, 3, 1)
	
	--button side
	circall(60, 70, 30, 2, 1)
	
	--button top
	circall(60, (btn(⬇️) and 65 or 60), 30, 3, 1)
	
	--print menu text
	color(1)
	print("\^w\^tsuper press down")
	print("remake deluxe final mix core +r")
	print("press ⬇️ to play!", 27, 120)
end

function update_main()
	-- stage 0 is initial splash screen
	if stage == 0 then
		-- tick down timer if nothing is pressed...
		-- ...but reset it if something is pressed.
		timer = btn() < 1 and timer-1 or maxtimer
		
		-- check for "press nothing" ending
		if timer < 1 then init_end(3) end
		
		-- todo: check for left presses for the "meet ☉" ending
		
		-- finally, check for a down press (like any sane developer would've done first)
		if btn(⬇️) then stage = 1; timer = 5 * 30 end
	--end of stage 0
	elseif stage == 1 then
		if btn(⬇️) then 
			timer = timer - 1
			if timer < 1 then stage = 2; scene = 2 end-- bad ending
		else --i.e. if ⬇️ is released
			init_end(1) end -- good ending
	end--of stage 1
end--of _update()
-->8
-- ⧗ cutscenes (wip)

function init_end(temps)
	stage = 2
	scene = temps
	timedir = 1
	timer = 0
end

function draw_end()
	--bg
	cls(1)	
	--temporary ending text
	color(4)
	write_box(text_good)
end	

function update_end()
	timer += timedir
	if timer % maxtimer then timedir *= -1 end
end

function write_box(text)
	i = 1
	while i <= #text and timer == 0 do
		y = 0
		for _=1,3  do
			print(text[i], hcenter(text[i]), y)
			y += 10
			i += 1
			end
	end
end

-- ending text
	--editor's note: how am i supposed to make walls of text in pico-8?
	--lzw seems like overkill, but these feel like headaches waiting to happen.
text_good = split([[and so, our hero
bravely stepped
into the street,
victorious against
the great evil that
was...

the down button

our great hero,
having slain the
mighty beast...]], '\n')
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d0501d050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
