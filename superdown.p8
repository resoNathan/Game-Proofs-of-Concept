pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ⬇️⬇️⬇️ an original game ⬇️⬇️⬇️
-- ⬇️⬇️⬇️  by @resonathan  ⬇️⬇️⬇️

--[[ spoiler warning
if you have not played all
endings and don't want to know
what they are, stop reading
this code.

a b a n d o n   a l l   h o p e
  y e   p r o g r a m m e r s
 w h o   e n t e r   h e r e .

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
]]--


-->8
-- ⌂ required and helper funcs
function _init()
	--debug menu
	menuitem(1,"debug: timer 2 sec",function() timer=60 end)

	--custom color palette
	--poke(0x5f2e, 1) --changes color consoleside (i think)
	--pal({128, 5, 6, 7} ,1)
	pal({128, 5, 6, 7,  5,6,7,6} ,1)
	
	-- variable declarations
	stage = 0
	maxtimer = 30 * 30 --seconds * frames
	timer = maxtimer
	scene = 0
	music(-1)
	sfx(-1)
end--of _init()

function _draw()
	if stage < -1 then --do nothing
	elseif stage >= 2 then draw_end()
	else draw_main() end
end

function _update()
	if stage < 0 then --do nothing
	elseif stage < 2 then update_main()
	elseif stage >= 2 then update_end() end
end

-------------------------------
				-- helper functions --
function circall(x,y,r,inner,outer)
	circfill(x,y,r,inner)
	circ(x,y,r,outer)
end

function textsplit(para)
	return split(para, '\n')
end

function blackout(t,s,c)
	stage=-9
	for i=1,t do
		cls(c)
		flip()
	end
	stage=s
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
-- ⬇️ button screen

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
			if timer < 1 then hold_scare() end-- hold ending
		else --i.e. if ⬇️ is released
			sfx(2);init_end(1) end -- good ending
	end--of stage 1
end--of _update()

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
	print(timer<=10 and "press ⬅️ to pray!" or "press ⬇️ to play!", 27, 120)
end
-->8
-- ⧗ cutscenes

function init_end(temps)
	scene = temps
	stage = 2
	timedir = 1
	timer = 0
	maxtimer = 30*3.5
	bar = 1
	
	texty = 50
	dialogue = textsplit(scnscript1[scene])
end

function ctn_adv()
	dialogue=textsplit(scnscript2[scene])
	bar=1
	texty=80
	stage += 1
	if stage == 3 then music(8) end
end

function draw_end()
	--bg
	cls(1)	
	--ending text
	color(4)
	write_box(dialogue,bar,texty)
	--blocker
	rectfill(timer*2,texty,127,127,1)
	
	--sunset image
	if stage==3 then
		sspr(8,0,64,32,0,0,128,64)
	end
	
	--timer (for testing)
	--print(timer,0,100,4)
end	

function update_end()
	timer += timedir
	if timer % maxtimer == 0 then timedir *= -1 end
	if timer == 0 then bar+=3; if bar>#dialogue then ctn_adv() end end
	
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
function hold_scare()
	--jumpscare
	for j=0,20 do
		sfx(3,-1,0,1)
		for i=0,j+5 do
		print("\^w\^t☉",rnd(137)-5,rnd(137)-5,1) end
		flip()
	end
	
	--reboot blinking
	blackout(71,-1,0)
	blackout(1,-1,4)
	print "\ai6c"
	blackout(12,-1,0)
	blackout(22,-1,1)
	
	--switch bg color (for scroll)
	pal(0,128,1)
	
	--write console log
	texty=0
	for _,logline in pairs(textsplit(text_error)) do
		print(logline,4)
		for i=0,1.2*#logline do
			flip()
		end
	end
	
	--switch bg color back
	pal(0,0,1)
	
	--shorter reboot
	blackout(13,-1,0)
	blackout(1,-1,4)
	blackout(9,-1,1)
	blackout(2,-1,0)
	
	--begin true cutscene
	init_end(2)
	ctn_adv()
end
-->8
-- ▤ ending dialogue
	--◆edit the order at the bottom
	--add an extra empty screen with '\n\n\n'..[[text here]]
	--author's note: how am i supposed to make walls of text in pico-8?
	--lzw seems like overkill, but these feel like headaches waiting to happen.

text_short = [[the following message
is left short on
purpose.]]

text_good = [[and so, our hero
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
!!!!!!!!!!!!!!!!!!]]

--ending 2 (wait)
text_wait_1=[[we watched the horizon
as the seconds
turned to minutes...
and the minutes turned
to hours... turned to
days... turned to months...
and yet, the promised
hero of legend
never arrived]]
text_wait_2=[[even still, we remain hopeful
for what the future
hold for us...
we remain vigilant
for what waits for
us in the future...
and above all else...
w e
r e m a i n
though our hero
may have left us
to fend for ourselves...
we must press onwards,
holding onto a single
comforting thought...
if we are what's left...
then we have been left
in capable hands.]]
--ending 3 (hold)
text_error=[[exited with error code 125620:
reason for crash:
unexpected entity found


begin troubleshooting...
attempting to locate entity:
success
	location:
	title screen

attempting to eliminate entity: 
fail
attempting to reenforce barrier: 
fail
att3mpting to load music:
f█il
attempting to access title: 
fail
attempting to access ending: 
partial success
attempting to load ending:
	good ending:
	fail
	bad ending:
	fail
	686f6c646c656674.rom:
		error: unknown
		flagged for remediation
	contingency ending: 
	success
attempting to reboot console:]]
text_contingency=[[]]

--script placements
scnscript1={text_short,text_wait_1,text_short,text_short}
scnscript2={text_good,text_wait_2,text_wait_2,text_short}

__gfx__
00000000222233333333333333333333333333333333333333333333333333333333222200000000000000000000000000000000000000000000000000000000
00000000244433333333333333333333333333333333333333333333333333333333444200000000000000000000000000000000000000000000000000000000
00700700243333333333333333333333333333333333333333333333333333333333334200000000000000000000000000000000000000000000000000000000
00077000243333333333333333333333333333333333333333333333333333333333334200000000000000000000000000000000000000000000000000000000
00077000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00700700333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333313333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333313333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333311113333113333333333333333333333313333333331333333333333333300000000000000000000000000000000000000000000000000000000
00000000333113311333133333333333333333333333313333333331333331333333333300000000000000000000000000000000000000000000000000000000
00000000333133331133133333333333333333333333133333333313333331333333333300000000000000000000000000000000000000000000000000000000
00000000333133331131333333333333333333333333133333333313333331333333333300000000000000000000000000000000000000000000000000000000
00000000333111111331333333333333333333331113113333333313333331333333333300000000000000000000000000000000000000000000000000000000
00000000333313333331333311113333333333311313113333333313333331333333333300000000000000000000000000000000000000000000000000000000
00000000333313333331333113313333311333113313111333313313333313333333333300000000000000000000000000000000000000000000000000000000
00000000333311333311333133313333113333133113131311113313333313333333333300000000000000000000000000000000000000000000000000000000
00000000333331333313333133111331133333131133131313113133333313111133111300000000000000000000000000000000000000000000000000000000
00000000333331333313333133131331333333111333131313113133311313133131133300000000000000000000000000000000000000000000000000000000
00000000333331333313333131131331333333133333131313133133133133131131333300000000000000000000000000000000000000000000000000000000
00000000333331333313333111331331333333113333131311133133133133113331333300000000000000000000000000000000000000000000000000000000
00000000333333333313333333331331111333311333131311333113111133113331333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333331333331113333333133333333113333333311331333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000333333333333333333333333333333333333333333333333333333333333333300000000000000000000000000000000000000000000000000000000
00000000243333333333333333333333333333333333333333333333333333333333334200000000000000000000000000000000000000000000000000000000
00000000243333333333333333333333333333333333333333333333333333333333334200000000000000000000000000000000000000000000000000000000
00000000244433333333333333333333333333333333333333333333333333333333444200000000000000000000000000000000000000000000000000000000
00000000222233333333333333333333333333333333333333333333333333333333222200000000000000000000000000000000000000000000000000000000
__label__
77gggg77gg77gg77gggggg77gggggg77gggggg7777777777gggggg77gggggg77gggggg7777gggg7777gggg7777777777gggg777777gggg77gg77gg77gggg7777
77gggg77gg77gg77gggggg77gggggg77gggggg7777777777gggggg77gggggg77gggggg7777gggg7777gggg7777777777gggg777777gggg77gg77gg77gggg7777
gg777777gg77gg77gg77gg77gg777777gg77gg7777777777gg77gg77gg77gg77gg777777gg777777gg77777777777777gg77gg77gg77gg77gg77gg77gg77gg77
gg777777gg77gg77gg77gg77gg777777gg77gg7777777777gg77gg77gg77gg77gg777777gg777777gg77777777777777gg77gg77gg77gg77gg77gg77gg77gg77
gggggg77gg77gg77gggggg77gggg7777gggg777777777777gggggg77gggg7777gggg7777gggggg77gggggg7777777777gg77gg77gg77gg77gg77gg77gg77gg77
gggggg77gg77gg77gggggg77gggg7777gggg777777777777gggggg77gggg7777gggg7777gggggg77gggggg7777777777gg77gg77gg77gg77gg77gg77gg77gg77
7777gg77gg77gg77gg777777gg777777gg77gg7777777777gg777777gg77gg77gg7777777777gg777777gg7777777777gg77gg77gg77gg77gggggg77gg77gg77
7777gg77gg77gg77gg777777gg777777gg77gg7777777777gg777777gg77gg77gg7777777777gg777777gg7777777777gg77gg77gg77gg77gggggg77gg77gg77
gggg777777gggg77gg777777gggggg77gg77gg7777777777gg777777gg77gg77gggggg77gggg7777gggg777777777777gggggg77gggg7777gggggg77gg77gg77
gggg777777gggg77gg777777gggggg77gg77gg7777777777gg777777gg77gg77gggggg77gggg7777gggg777777777777gggggg77gggg7777gggggg77gg77gg77
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
ggg7ggg7ggg7ggg7g7g7ggg77777gg77ggg7g777g7g7g7g7ggg77777ggg7ggg7gg77ggg7g7777777ggg7ggg7g7g777777gg77gg7ggg7ggg777777777ggg77777
g7g7g777ggg7g7g7g7g7g7777777g7g7g777g777g7g7g7g7g7777777g7777g77g7g7g7g7g7777777ggg77g77g7g77777g777g7g7g7g7g77777777g77g7g77777
gg77gg77g7g7ggg7gg77gg777777g7g7gg77g777g7g77g77gg777777gg777g77g7g7ggg7g7777777g7g77g777g777777g777g7g7gg77gg777777ggg7gg777777
g7g7g777g7g7g7g7g7g7g7777777g7g7g777g777g7g7g7g7g7777777g7777g77g7g7g7g7g7777777g7g77g77g7g77777g777g7g7g7g7g77777777g77g7g77777
g7g7ggg7g7g7g7g7g7g7ggg77777ggg7ggg7ggg77gg7g7g7ggg77777g777ggg7g7g7g7g7ggg77777g7g7ggg7g7g777777gg7gg77g7g7ggg777777777g7g77777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777ggggggggggg77777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777gggg66666666666gggg7777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777gg6666666666666666666gg77777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777ggg66666666666666666666666ggg77777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777g66666666666666666666666666666g7777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777gg6666666666666666666666666666666gg77777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777g66666666666666666666666666666666666g7777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777g6666666666666666666666666666666666666g777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777g666666666666666666666666666666666666666g77777777777777777777777777777777777777777777777
777777777777777777777777777777777777777g66666666666666666666666666666666666666666g7777777777777777777777777777777777777777777777
77777777777777777777777777777777777777g6666666666666666666666666666666666666666666g777777777777777777777777777777777777777777777
7777777777777777777777777777777777777g666666666666666666666666666666666666666666666g77777777777777777777777777777777777777777777
777777777777777777777777777777777777g66666666666666666666666666666666666666666666666g7777777777777777777777777777777777777777777
77777777777777777777777777777777777g6666666666666666666666666666666666666666666666666g777777777777777777777777777777777777777777
77777777777777777777777777777777777g6666666666666666666666666666666666666666666666666g777777777777777777777777777777777777777777
7777777777777777777777777777777777g666666666666666666666666666666666666666666666666666g77777777777777777777777777777777777777777
777777777777777777777777777777777g66666666666666666666666666666666666666666666666666666g7777777777777777777777777777777777777777
77777777777777777777777777777777gg66666666666666666666666666666666666666666666666666666gg777777777777777777777777777777777777777
7777777777777777777777777777777g6g66666666666666666666666666666666666666666666666666666g6g77777777777777777777777777777777777777
777777777777777777777777777777g6g6666666666666666666666666666666666666666666666666666666g6g7777777777777777777777777777777777777
777777777777777777777777777777g6g6666666666666666666666666666666666666666666666666666666g6g7777777777777777777777777777777777777
77777777777777777777777777777g6g666666666666666666666666666666666666666666666666666666666g6g777777777777777777777777777777777777
7777777777777777777777777777g66g666666666666666666666666666666666666666666666666666666666g66g77777777777777777777777777777777777
7777777777777777777777777777g66g666666666666666666666666666666666666666666666666666666666g66g77777777777777777777777777777777777
777777777777777777777777777g666g666666666666666666666666666666666666666666666666666666666g666g7777777777777777777777777777777777
777777777777777777777777777g66g66666666666666666666666666666666666666666666666666666666666g66g7777777777777777777777777777777777
77777777777777777777777777g666g66666666666666666666666666666666666666666666666666666666666g666g777777777777777777777777777777777
77777777777777777777777777g666g66666666666666666666666666666666666666666666666666666666666g666g777777777777777777777777777777777
7777777777777777777777777g6666g66666666666666666666666666666666666666666666666666666666666g6666g77777777777777777777777777777777
7777777777777777777777777g6666g66666666666666666666666666666666666666666666666666666666666g6666g77777777777777777777777777777777
7777777777777777777777777g6666g66666666666666666666666666666666666666666666666666666666666g6666g77777777777777777777777777777777
777777777777777777777777g66666g66666666666666666666666666666666666666666666666666666666666g66666g7777777777777777777777777777777
777777777777777777777777g66666g66666666666666666666666666666666666666666666666666666666666g66666g7777777777777777777777777777777
777777777777777777777777g66666g66666666666666666666666666666666666666666666666666666666666g66666g7777777777777777777777777777777
777777777777777777777777g66666g66666666666666666666666666666666666666666666666666666666666g66666g7777777777777777777777777777777
77777777777777777777777g666666g66666666666666666666666666666666666666666666666666666666666g666666g777777777777777777777777777777
77777777777777777777777g666666gg666666666666666666666666666666666666666666666666666666666gg666666g777777777777777777777777777777
77777777777777777777777g666666gg666666666666666666666666666666666666666666666666666666666gg666666g777777777777777777777777777777
77777777777777777777777g666666gg666666666666666666666666666666666666666666666666666666666gg666666g777777777777777777777777777777
77777777777777777777777g666666gg666666666666666666666666666666666666666666666666666666666gg666666g777777777777777777777777777777
77777777777777777777777g666666g5g6666666666666666666666666666666666666666666666666666666g5g666666g777777777777777777777777777777
77777777777777777777777g666666g5g6666666666666666666666666666666666666666666666666666666g5g666666g777777777777777777777777777777
77777777777777777777777g666666g55g66666666666666666666666666666666666666666666666666666g55g666666g777777777777777777777777777777
77777777777777777777777g666666g55g66666666666666666666666666666666666666666666666666666g55g666666g777777777777777777777777777777
77777777777777777777777g666666g55g66666666666666666666666666666666666666666666666666666g55g666666g777777777777777777777777777777
77777777777777777777777g666666g555g666666666666666666666666666666666666666666666666666g555g666666g777777777777777777777777777777
77777777777777777777777g6666666g555g6666666666666666666666666666666666666666666666666g555g6666666g777777777777777777777777777777
77777777777777777777777g6666666g555g6666666666666666666666666666666666666666666666666g555g6666666g777777777777777777777777777777
777777777777777777777777g666666g5555g66666666666666666666666666666666666666666666666g5555g666666g7777777777777777777777777777777
777777777777777777777777g666666g55555g666666666666666666666666666666666666666666666g55555g666666g7777777777777777777777777777777
777777777777777777777777g6666666g55555g6666666666666666666666666666666666666666666g55555g6666666g7777777777777777777777777777777
777777777777777777777777g6666666g555555g66666666666666666666666666666666666666666g555555g6666666g7777777777777777777777777777777
7777777777777777777777777g6666666g555555g666666666666666666666666666666666666666g555555g6666666g77777777777777777777777777777777
7777777777777777777777777g6666666g5555555g6666666666666666666666666666666666666g5555555g6666666g77777777777777777777777777777777
7777777777777777777777777g6666666g55555555g66666666666666666666666666666666666g55555555g6666666g77777777777777777777777777777777
77777777777777777777777777g6666666g55555555gg6666666666666666666666666666666gg55555555g6666666g777777777777777777777777777777777
77777777777777777777777777g66666666g555555555g66666666666666666666666666666g555555555g66666666g777777777777777777777777777777777
777777777777777777777777777g6666666g5555555555ggg66666666666666666666666ggg5555555555g6666666g7777777777777777777777777777777777
777777777777777777777777777g66666666g555555555555gg6666666666666666666gg555555555555g66666666g7777777777777777777777777777777777
7777777777777777777777777777g66666666g5555555555555gggg66666666666gggg5555555555555g66666666g77777777777777777777777777777777777
7777777777777777777777777777g666666666g5555555555555555ggggggggggg5555555555555555g666666666g77777777777777777777777777777777777
77777777777777777777777777777g666666666g55555555555555555555555555555555555555555g666666666g777777777777777777777777777777777777
777777777777777777777777777777g666666666g555555555555555555555555555555555555555g666666666g7777777777777777777777777777777777777
777777777777777777777777777777g6666666666g5555555555555555555555555555555555555g6666666666g7777777777777777777777777777777777777
7777777777777777777777777777777g6666666666g55555555555555555555555555555555555g6666666666g77777777777777777777777777777777777777
77777777777777777777777777777777g6666666666gg5555555555555555555555555555555gg6666666666g777777777777777777777777777777777777777
777777777777777777777777777777777g66666666666g55555555555555555555555555555g66666666666g7777777777777777777777777777777777777777
7777777777777777777777777777777777g66666666666ggg55555555555555555555555ggg66666666666g77777777777777777777777777777777777777777
77777777777777777777777777777777777g6666666666666gg5555555555555555555gg6666666666666g777777777777777777777777777777777777777777
777777777777777777777777777777777777g66666666666666gggg55555555555gggg66666666666666g7777777777777777777777777777777777777777777
7777777777777777777777777777777777777g66666666666666666ggggggggggg66666666666666666g77777777777777777777777777777777777777777777
77777777777777777777777777777777777777gg66666666666666666666666666666666666666666gg777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777g666666666666666666666666666666666666666g77777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777gg66666666666666666666666666666666666gg777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777gg6666666666666666666666666666666gg77777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777gg666666666666666666666666666gg7777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777ggg666666666666666666666ggg777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777gggg6666666666666gggg777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777ggggggggggggg7777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777ggg7ggg7ggg77gg77gg777777ggggg777777ggg77gg77777ggg7g777ggg7g7g77g77777777777777777777777777777777777
777777777777777777777777777g7g7g7g7g777g777g7777777gg777gg777777g77g7g77777g7g7g777g7g7g7g77g77777777777777777777777777777777777
777777777777777777777777777ggg7gg77gg77ggg7ggg77777gg777gg777777g77g7g77777ggg7g777ggg7ggg77g77777777777777777777777777777777777
777777777777777777777777777g777g7g7g77777g777g77777ggg7ggg777777g77g7g77777g777g777g7g777g77777777777777777777777777777777777777
777777777777777777777777777g777g7g7ggg7gg77gg7777777ggggg7777777g77gg777777g777ggg7g7g7ggg77g77777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__map__
1010101010101010101010000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002467024650156301561000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
000100001d4301a640174501864017440156300e43002020030500105002050020500105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900001d6601a650176501864017640156300e6300b620096100961005610026100161000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
050a00011c35000300003000030000300003000030018300183001830018300183001830018300183000030000300003000030000300003000030000300003000030000300003000030000300003000030000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
990a00002445024450244502445024450244502445024450004000040000400004001d450004001d45000400244502445000400004001d4501d450004000040024450244501d4501d45024450244502945029450
990a00002445024450244502445024450244502445024450014000140001400014000140001400014000140001400014000140001400014000140001400014002445001400014002445001400014002445001400
990a00002545025450254502545025450254502545025450014000140001400014001e450014001e45001400254502545001400014001e4501e450014000140025450254501e4501e45025450254502a4502a450
990a00002545025450254502545025450254502545025450024000240002400024000240002400024000240002400024000240002400024000240002400024002545002400024002545002400024002545002400
990a00002245022450224502245022450224502245022450004000040000400004001b450004001b45000400224502245000400004001b4501b450004000040022450224501b4501b45022450224502745027450
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
b1140000253402534025345203401d3401d3401d3401d3401d34500300003000030020340203402534025340243402434024345203401b3401b3401b3401b3401b34500305003050030520340203402434024340
01140000195301953014530145301d5301d5301453014530205302053014530145301d5301d5301453014530185301853014530145301b5301b5301453014530205302053014530145301b5301b5301453014530
a11400000d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d0500d05008050080500805008050080500805008050080500805008050080500805008050080500805008050
591400000305003050030500305003050030500305003050030500305003050030500305003050030500305005050050500505005050050500505005050050500505005050050500505005050050500505005050
b1140000223402234022345203401f3401f3401f3401f3401f3450030000300003002234022340223402234021340213401d3401d34022340223401d3401d3402434024340243402434021340213402134021340
0114000016530165300f5300f5301b5301b5300f5300f5301f5301f5300f5300f5301b5301b5300f5300f53015530155301153011530185301853011530115301d5301d530115301153018530185301153011530
b1140000223402234022345203401f3401f3401f3401f3401f3450030000300003002234022340223402234024350243552435524355243502435524350243552435024355243552435524350243552435024355
591400000305003050030500305003050030500305003050030500305003050030500305003050030500305000050000500005000050000500005000050000500c0500c0500c0500c0500c0500c0500c0500c050
0014000016530165300f5300f5301b5301b5300f5300f5301f5301f5300f5300f5301b5301b5300f5300f530185301853013530135301c5301c53013530135301f5301f53018530185301c5301c5301853018530
__music__
01 0a424344
00 0b141644
00 0c151744
00 0d424344
00 0e424344
00 0e424344
00 0a424344
02 0b424344
01 1e1f6020
00 22234321
00 1e1f6020
02 24264325

