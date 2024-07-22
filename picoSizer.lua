FUNCTION _INIT()
  menu = {"pos_x", "pos_y", "size_x", "size_y"}
  pos_x = 0
  pos_y = 0
  size_x = 50
  size_y = 50
  
  pointer = 0
END
 
FUNCTION _UPDATE()
  --press up/down (2/3) to change the selected property
  if (btnp(2)) pointer = (pointer + 1) % 5
  if (btnp(3)) pointer = (pointer - 1) % 5
  
  if (btnp(0))
END
 
FUNCTION _DRAW()
  --grey bg
  CLS(5)
  
  --draw a green rectangle with the chosen parameters
  rect(pos_x, pos_y, pos_x+size_x, pos_y+size_y, 3)
  
  --display the 4 parameters and their values
	--color it yellow (10) if it's selected, or white (7) if it's not
  print("pos_x: "..pos_x, 0, 10, pointer==0 and 10 or 7)
  print("pos_y: "..pos_y, 0, 20, pointer==1 and 10 or 7)
  print("size_x: "..size_x, 0, 30, pointer==2 and 10 or 7)
  print("size_y: "..size_y, 0, 40, pointer==3 and 10 or 7)
  
  --write instructions (may need to be updated later)
  print("use up/down to select, use left/right to change, hold 🅾️ to change by 10", 0, 90, 10)
  
END