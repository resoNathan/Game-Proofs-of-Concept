def blankDict():
    alpha = {}
    for i in range(20, 127): #40-127 for alphabet only
        alpha[chr(i)] = chr(i)
    return alpha

def lzwCompress(input: str) -> str:
    key = blankDict()
    i = 128 #Begin at extended character codes (Ç)
    p = input[0]
    out = ""

    for c in input[1:]:
        if (p + c) in key:
            p = p + c
        else:
            out += key[p]
            key[p + c] = chr(i)
            i += 1
            p = c
    
    return out + p

def lzwExpand(input: str) -> str:
    key = blankDict()
    i = 128 #Begin at extended character codes (Ç)
    old = input[0]
    s, c, out = "", "", old

    for new in input[1:]:
        if new in key:
            s = key[new]
        else:
            s = key[old] + c
        out += s
        c = s[0]
        key[chr(i)] = key[old] + c
        old = new
        i+=1
    
    print (i)
    return out

testThis = "thisisthe"
testPeter = "peterpiperpickedapeckofpickledpeppersapeckofpickledpepperspeterpiperpickedifpeterpiperpickedapeckofpickledpepperswheresthepeckofpickledpepperspeterpiperpicked"
testWhat = "What is love? Baby don't hurt me, don't hurt me. No more!"
testLorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec aliquam tempus fringilla. Maecenas sollicitudin felis et tellus finibus, ut rhoncus purus interdum. Donec id rhoncus enim. Phasellus porta at urna ut porttitor. Aliquam luctus, velit quis efficitur lobortis, orci ligula hendrerit augue, non ullamcorper quam ipsum in quam. Fusce quis ex ut neque molestie convallis. Nunc ut ipsum odio. Quisque faucibus quis nisl id consequat. Duis vitae nunc enim. Nullam nec hendrerit augue. Maecenas pulvinar condimentum ligula, nec mattis est vulputate vitae. Duis ullamcorper ex tellus, ac porta sem mattis ac. Donec in sollicitudin diam. Ut maximus ligula elit, ut venenatis odio elementum non. Donec molestie augue tellus. Nullam mollis sem at fermentum facilisis."

comThis = lzwCompress(testLorem)
print (comThis)
print (lzwExpand(comThis))