function _init()
  --menu = {"pos_x", "pos_y", "size_x", "size_y"}
  vals = {0, 0, 50, 50}
  pointer = 1
  amount = 1
end
 
function _update()
  --press up/down (2/3) to change the selected property
  --modulo math for 1 index: (pointer +/- 1 - 1) % 5 + 1
  if (btnp(3)) pointer = pointer % 4 + 1
  if (btnp(2)) pointer = (pointer - 2) % 4 + 1
  
  --press x/o to change the amount to alter by
  amount = btn(🅾️) and 5 or 1
  amount = btn(❎) and 10 or amount
  
  --press left/right (0/1) to alter the selected property
  if (btnp(0)) vals[pointer] = vals[pointer] - amount
  if (btnp(1)) vals[pointer] = vals[pointer] + amount
end
 
function _draw()
  --grey bg
  cls(1)
  
  --draw a green rectangle with the chosen parameters
  --rect(pos_x, pos_y, pos_x+size_x, pos_y+size_y, 3)
  rectfill(vals[1], vals[2], vals[1]+vals[3], vals[2]+vals[4], 3)
  
  --display the 4 parameters and their values
	--color it yellow (10) if it's selected, or white (7) if it's not
  print("pos_x: "..vals[1], 2, 10, pointer==1 and 10 or 7)
  print("pos_y: "..vals[2], 2, 20, pointer==2 and 10 or 7)
  print("size_x: "..vals[3], 2, 30, pointer==3 and 10 or 7)
  print("size_y: "..vals[4], 2, 40, pointer==4 and 10 or 7)
  
  --write instructions (may need to be updated later)
  print("use ⬆️/⬇️ to select a property", 2, 80, 7)
  print("use ⬅️/➡️ to change its value", 2, 90, 7)
  print("hold 🅾️ for x5, hold ❎ for x10", 2, 100, 7)
  
end
