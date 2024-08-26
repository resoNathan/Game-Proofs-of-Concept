pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ★ notes
--[[ super press down
created by @resonathan
nathan roberts 2024

scenes (endings):
1: good ending (press and release)
2: bad ending (don't press anything)
3: never ending (press and hold)
4: beginning of the end (press or hold left)

stages (game states):
-2: ☉ ending "jumpscare"
-1: functionless button
0: main screen
1: 0 w/ button pressed
2: cutscene

abandon all hope ye
good programmers who
enter here.]]--


-->8
-- ⌂ required and helper funcs
function _init()
	--custom color palette
	--poke(0x5f2e, 1) --changes color consoleside (i think)
	--pal({128, 5, 6, 7} ,1)
	pal({128, 5, 6, 7,  5,6,7,6} ,1)
	
	-- variable declarations
	stage = 0
	maxtimer = 30 * 30 --seconds * frames
	timer = maxtimer
	scene = 0
end--of _init()

function _draw()
	if stage < -1 then --do nothing
	elseif stage == 2 then draw_end()
	else draw_main() end
end

function _update()
	if stage == -2 then update_ohno()
	elseif stage < 0 then --do nothing
	elseif stage < 2 then update_main()
	elseif stage == 2 then update_end() end
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
	print((rnd(50)>timer and stage == 1) and "press ⬅️ to pray!" or "press ⬇️ to play!", 27, 120)
end

function update_main()
	-- stage 0 is initial splash screen
	if stage == 0 then
		-- tick down timer if nothing is pressed...
		-- ...but reset it if something is pressed.
		timer = btn() < 1 and timer-1 or maxtimer
		-- tick tock
		if timer%30==0 and timer<10*30 then sfx(1) end
		
		-- check for "press nothing" ending
		if timer < 1 then init_end(2) end
		
		-- todo: check for left presses for the "meet ☉" ending
		
		-- finally, check for a down press (like any sane developer would've done first)
		if btn(⬇️) then sfx(0);stage = 1; timer = 5 * 30 end
	--end of stage 0
	elseif stage == 1 then
		if btn(⬇️) then 
			timer = timer - 1
			if timer < 1 then timer = 30; stage = -2 end-- bad ending
		else --i.e. if ⬇️ is released
			sfx(2);init_end(1) end -- good ending
	end--of stage 1
end--of _update()
-->8
-- ⧗ cutscenes

function init_end(temps)
	stage = 2
	scene = temps
	timedir = 1
	timer = 0
	maxtimer = 30*5
	bar = 1
end

function draw_end()
	--bg
	cls(1)	
	--ending text
	color(4)
	write_box(text_good,bar,50)
	--blocker
	rectfill(timer,50,127,127,1)
	
	--timer (for testing)
	--print(timer,0,100,4)
end	

function update_end()
	timer += timedir
	if timer % maxtimer == 0 then timedir *= -1 end
	if timer == 0 then bar=(bar+3)%#text_good end
	
	--debug back to main menu
	if btn(❎) then _init() end
end

function write_box(text, s, y)
	for i=s,s+2  do
		print(text[i], hcenter(text[i]), y)
		y += 10
	end
end
-->8
-- ☉ scary vfx

function update_ohno()
	if timer < 1 then  init_end(3)
	else timer -= 1 end
	
	sfx(3,-1,0,1)
	for i=0,15 do
	print("\^w\^t☉",rnd(127),rnd(127),1) end
end
-->8
-- ▤ ending dialogue
	--add an extra empty screen with '\n\n\n'..[[text here]]
	--editor's note: how am i supposed to make walls of text in pico-8?
	--lzw seems like overkill, but these feel like headaches waiting to happen.
text_good = split([[and so, our hero
bravely stepped
into the street,
victorious against
the great evil that
was...

t h e   d o w n   b u t t o n

our great hero,
having slain the
mighty beast...
!!!!!!!!!!!!!!!!!!
todo: write ending
!!!!!!!!!!!!!!!!!!]], '\n')

--ending 3 (hold)
text_error=[[exited with error code 51331:
unexpected entity on title screen
attempting to troubleshoot...
eliminate entity: 
fail
reenforce barrier: 
fail
reenf🅾️rce █▒██▒
f█il
access title: 
fail
access ending: 
partial success
load contingency ending: 
success
reboot in safe mode:]]
text_contingency=[[]]
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111144444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111114444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111144440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111114440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002467024650156301561000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
000100001d4301a640174501864017440156300e43002020030500105002050020500105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900001d6601a650176501864017640156300e6300b620096100961005610026100161000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
051000001c35000300003000030000300003000030000300183001830018300183001830018300183001830000300003000030000300003000030000300003000030000300003000030000300003000030000300
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002405024050240502405024050240502405024050000000000000000000001d050000001d05000000240502405000000000001d0501d050000000000024050240501d0501d05024050240502905029050
000a00002405024050240502405024050240502405024050010000100001000010000100001000010000100001000010000100001000010000100001000010002405001000010002405001000010002405001000
000a00002505025050250502505025050250502505025050010000100001000010001e050010001e05001000250502505001000010001e0501e050010000100025050250501e0501e05025050250502a0502a050
000a00002505025050250502505025050250502505025050020000200002000020000200002000020000200002000020000200002000020000200002000020002505002000020002505002000020002505002000
000a00002205022050220502205022050220502205022050000000000000000000001b050000001b05000000220502205000000000001b0501b050000000000022050220501b0501b05022050220502705027050
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000007000070000700007000070000700007000070011750117501175011750187501875018750187501d7501d7501d7501d750117501175011750117501875018750187501875011750117501175011750
000a00000d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d050
000a000000000000000000000000000000000000000000000c0500c0500c0500c0500c0500c0500c0500c05011050110501105011050110501105011050110501305013050130501305013050130501305013050
000a00001105011050110501105011050110501105011050110501105011050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 0a424344
00 0b141644
00 0c151744
00 0c424344
00 0e424344
00 0e424344
00 0a424344
02 0b424344

