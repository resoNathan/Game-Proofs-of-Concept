pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _draw()
	--will eventually be replaced with a mode switch
	draw_main()
end

function draw_main()
	--bg
	cls()
	
	--plate
	circfill(60, 71, 37, 5)
	
	--button side
	circfill(60, 70, 30, 3)
	
	--button top
	circfill(60, (btn(⬇️) and 65 or 60), 30, 11)
	
	--test
	print("\^w\^tsuper press down")
	print("remake deluxe final mix core +r")
	print("press ⬇️ to play!", 27, 120)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
